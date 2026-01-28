#!/bin/bash

# --- 1. CONFIGURAÇÕES E AMBIENTE ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.abe_allstars"
export WINEPREFIX="$DEST/wine_prefix"
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8
DLL_OVERRIDES="winhttp=n,b"

# Verificação de Zenity
if ! command -v zenity >/dev/null 2>&1; then
    echo "Erro: Zenity não encontrado."
    exit 1
fi

error_exit() {
    zenity --error --text="$1" --width=300
    exit 1
}

# --- 2. GESTÃO DE INSTÂNCIAS ---
if pgrep -f "All Stars.exe" >/dev/null; then
    zenity --question --title="Jogo em Execução" \
           --text="O jogo já está aberto ou travado.\n\nDeseja encerrar a instância atual?" --width=350
    if [ $? -eq 0 ]; then
        wineserver -k && sleep 2
    else
        exit 0
    fi
fi

# --- 3. LÓGICA DE INSTALAÇÃO ---
if [ ! -f "$DEST/All Stars.exe" ]; then
    GAME_PATH=$(zenity --file-selection --directory --title="Selecione a pasta original do jogo")
    [ -z "$GAME_PATH" ] && exit 1

    mkdir -p "$DEST"
    FILES=("All Stars.exe" "All Stars_Data" "GameAssembly.dll" "UnityPlayer.dll" "baselib.dll")
    
    (
        for f in "${FILES[@]}"; do
            echo "# Copiando $f..."
            cp -r "$GAME_PATH/$f" "$DEST/" 2>/dev/null
        done
        echo "100"
    ) | zenity --progress --title="Instalando..." --auto-close --width=400
fi

# --- 4. INSTALAÇÃO DO LAUNCHER E ÍCONES ---
cp "$0" "$DEST/run.sh"
chmod +x "$DEST/run.sh"

# Busca dinâmica do ícone: tenta assets, depois a pasta do script
if [ -f "$SCRIPT_DIR/../assets/icon.png" ]; then
    cp "$SCRIPT_DIR/../assets/icon.png" "$DEST/icon.png"
elif [ -f "$SCRIPT_DIR/assets/icon.png" ]; then
    cp "$SCRIPT_DIR/assets/icon.png" "$DEST/icon.png"
elif [ -f "$SCRIPT_DIR/icon.png" ]; then
    cp "$SCRIPT_DIR/icon.png" "$DEST/icon.png"
fi

# Criar atalho .desktop (Associação via StartupWMClass)
DESKTOP_FILE="$HOME/.local/share/applications/angry-birds-epic-all-stars.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Angry Birds Epic All Stars
Comment=Play Angry Birds Epic: All Stars on Linux
Exec=$DEST/run.sh
Icon=$DEST/icon.png
Terminal=false
Categories=Game;
StartupWMClass=all stars.exe
EOF

chmod +x "$DESKTOP_FILE"
# --- 5. EXECUÇÃO ---
# Força o idioma e limpa o terminal de mensagens de erro irrelevantes do Wine
wine reg add "HKEY_CURRENT_USER\Software\Rovio\Angry Birds Epic" /v "Language_h464735252" /t REG_SZ /d "Portuguese (Brazil)" /f > /dev/null 2>&1

cd "$DEST" || error_exit "Pasta do jogo inacessível."

# Lança o Zenity em background e armazena o PID para fechá-lo depois se necessário
zenity --info --text="Iniciando Angry Birds Epic: All Stars..." --timeout=2 --no-wrap --title="Launcher" &
ZEN_PID=$!

# O 'exec' substitui o processo do script pelo do Wine. 
# Adicionamos '2>/dev/null' para o terminal não ficar cuspindo logs inúteis.
WINEDLLOVERRIDES="$DLL_OVERRIDES" exec wine "All Stars.exe" > /dev/null 2>&1
