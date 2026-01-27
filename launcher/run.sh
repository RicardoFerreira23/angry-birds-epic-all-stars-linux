#!/bin/bash

# --- 1. CONFIGURAÇÕES E AMBIENTE ---
# Detecta onde o script está sendo executado para localizar assets
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.abe_allstars"
export WINEPREFIX="$DEST/wine_prefix"
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8
DLL_OVERRIDES="winhttp=n,b"

# Verificação de dependência visual
if ! command -v zenity >/dev/null 2>&1; then
    echo "Erro: Zenity não encontrado. Instale-o para usar este launcher."
    exit 1
fi

error_exit() {
    zenity --error --text="$1" --width=300
    exit 1
}

if ! command -v wine >/dev/null 2>&1; then
    error_exit "Wine não encontrado! Por favor, instale o Wine ou configure o Proton-GE."
fi

# --- 2. GESTÃO DE INSTÂNCIAS ---
# Verifica se o jogo já está rodando para evitar conflitos de arquivo
if pgrep -f "All Stars.exe" >/dev/null; then
    zenity --question --title="Jogo em Execução" \
           --text="O jogo já está aberto ou travado.\n\nDeseja encerrar a instância atual para reiniciar?" \
           --width=350
    if [ $? -eq 0 ]; then
        wineserver -k
        sleep 2
    else
        exit 0
    fi
fi

# --- 3. LÓGICA DE INSTALAÇÃO ---
if [ ! -f "$DEST/All Stars.exe" ]; then
    GAME_PATH=$(zenity --file-selection --directory --title="Selecione a pasta original do jogo")
    [ -z "$GAME_PATH" ] && exit 1

    mkdir -p "$DEST" || error_exit "Falha ao criar pasta de destino!"
    
    INSTALL_LOG="$DEST/install_log.txt"
    echo "--- Instalação: $(date) ---" > "$INSTALL_LOG"

    FILES=("All Stars.exe" "All Stars_Data" "GameAssembly.dll" "UnityPlayer.dll" "baselib.dll")
    
    (
        for f in "${FILES[@]}"; do
            SRC="$GAME_PATH/$f"
            echo "# Copiando $f..."
            if [ -e "$SRC" ]; then
                cp -r "$SRC" "$DEST/" >> "$INSTALL_LOG" 2>&1
            fi
        done
        echo "100"
    ) | zenity --progress --title="Instalando..." --text="Preparando arquivos..." --auto-close --width=400

    [ ! -f "$DEST/All Stars.exe" ] && error_exit "Erro na cópia! Verifica: $INSTALL_LOG"
fi

# --- 4. INSTALAÇÃO DO LAUNCHER NO SISTEMA ---
# Copia o próprio script e o ícone para o diretório fixo
cp "$0" "$DEST/run.sh"
chmod +x "$DEST/run.sh"

if [ -f "$SCRIPT_DIR/../assets/icon.png" ]; then
    cp "$SCRIPT_DIR/../assets/icon.png" "$DEST/icon.png"
fi

# Cria o atalho no menu com suporte duplo a StartupWMClass (Dock Fix)
DESKTOP_FILE="$HOME/.local/share/applications/angry-birds-epic-all-stars.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Angry Birds Epic: All Stars
Comment=Play Angry Birds Epic: All Stars on Linux
Exec=$DEST/run.sh
Icon=$DEST/icon.png
Terminal=false
Type=Application
Categories=Game;
StartupWMClass=all stars.exe
StartupWMClass=All Stars.exe
EOF

chmod +x "$DESKTOP_FILE"

# --- 5. EXECUÇÃO ---
# Força o idioma para PT-BR via Registro do Wine
wine reg add "HKEY_CURRENT_USER\Software\Rovio\Angry Birds Epic" /v "Language_h464735252" /t REG_SZ /d "Portuguese (Brazil)" /f > /dev/null 2>&1

cd "$DEST" || error_exit "Pasta do jogo inacessível."

# Feedback visual de carregamento
zenity --info --text="Iniciando Angry Birds Epic: All Stars..." --timeout=2 --no-wrap --title="Launcher" &

# Exec substitui o processo do script pelo do Wine (estabilidade máxima)
WINEDLLOVERRIDES="$DLL_OVERRIDES" exec wine "All Stars.exe"

# --- 6. FIX DEFINITIVO DO ÍCONE (DOCK/TASKBAR) ---
# Forçamos o ícone no cache do sistema para bater com a WM_CLASS detectada
ICON_HOME_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
mkdir -p "$ICON_HOME_DIR"

if [ -f "$DEST/icon.png" ]; then
    # Criamos um link ou cópia com o nome EXATO que o xprop revelou
    cp "$DEST/icon.png" "$ICON_HOME_DIR/all stars.exe.png"
    
    # Atualiza o cache de ícones do sistema para o GNOME/KDE perceberem a mudança
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons" >/dev/null 2>&1
fi