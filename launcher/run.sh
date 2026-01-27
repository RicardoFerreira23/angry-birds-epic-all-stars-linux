#!/bin/bash

# --- CONFIGURAÇÕES ---
DEST="$HOME/.abe_allstars"
export WINEPREFIX="$DEST/wine_prefix"
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8
DLL_OVERRIDES="winhttp=n,b"

# 1. Verificar se o Zenity está instalado (Primeira coisa!)
if ! command -v zenity >/dev/null 2>&1; then
    echo "Erro: Zenity não encontrado. Instale-o para usar este launcher."
    echo "Ubuntu/Debian: sudo apt install zenity"
    echo "Arch: sudo pacman -S zenity"
    exit 1
fi

error_exit() {
    zenity --error --text="$1" --width=300
    exit 1
}

# 2. Verificar se o Wine está instalado
if ! command -v wine >/dev/null 2>&1; then
    error_exit "Wine não encontrado! Por favor, instale o Wine ou configure o Proton-GE."
fi

# 3. Lógica de Instalação/Sincronização
if [ ! -f "$DEST/All Stars.exe" ]; then
    GAME_PATH=$(zenity --file-selection --directory --title="Instalação: Selecione a pasta original do jogo")
    [ -z "$GAME_PATH" ] && error_exit "Nenhuma pasta selecionada!"

    mkdir -p "$DEST" || error_exit "Falha ao criar pasta de destino!"
    
    # Criar/Limpar log de instalação
    INSTALL_LOG="$DEST/install_log.txt"
    echo "--- Início da Instalação: $(date) ---" > "$INSTALL_LOG"

    FILES=("All Stars.exe" "All Stars_Data" "GameAssembly.dll" "UnityPlayer.dll" "baselib.dll")
    
    (
        for f in "${FILES[@]}"; do
            SRC="$GAME_PATH/$f"
            echo "# Processando $f..."
            echo "[$(date +%T)] Verificando $SRC" >> "$INSTALL_LOG"
            
            if [ -e "$SRC" ]; then
                # Backup se já existir
                if [ -f "$DEST/$f" ]; then
                    echo "[$(date +%T)] Criando backup de $f" >> "$INSTALL_LOG"
                    mv "$DEST/$f" "$DEST/$f.bak"
                fi
                
                echo "[$(date +%T)] Copiando $f..." >> "$INSTALL_LOG"
                cp -r "$SRC" "$DEST/" >> "$INSTALL_LOG" 2>&1
            else
                echo "[$(date +%T)] AVISO: $f não encontrado na origem!" >> "$INSTALL_LOG"
            fi
        done
        echo "100"
    ) | zenity --progress --title="Instalando..." --text="Copiando arquivos..." --auto-close --width=400

    # Verificação de integridade
    if [ ! -f "$DEST/All Stars.exe" ]; then
        echo "[$(date +%T)] ERRO CRÍTICO: Executável não encontrado no destino!" >> "$INSTALL_LOG"
        error_exit "Erro na instalação! Verifique o log em: $INSTALL_LOG"
    fi

    echo "--- Instalação Concluída: $(date) ---" >> "$INSTALL_LOG"
    zenity --info --text="Instalação concluída! Clique em OK para iniciar." --width=300
fi

# 4. Configuração do Wine e Execução
wine reg add "HKEY_CURRENT_USER\Software\Rovio\Angry Birds Epic" /v "Language_h464735252" /t REG_SZ /d "Portuguese (Brazil)" /f > /dev/null 2>&1

cd "$DEST" || error_exit "Pasta do jogo inacessível."

# Lançar jogo em background com logs de runtime
WINEDLLOVERRIDES="$DLL_OVERRIDES" wine "All Stars.exe" > "$DEST/wine_log.txt" 2>&1 &

exit 0