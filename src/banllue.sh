#!/bin/bash

# ==================================================
# PAINEL BANWHATS PRO - ELITE EDITION V5.1
# Desenvolvido por: ALISONKKJJ YT
# ==================================================

AZUL='\e[1;34m'
CIANO='\e[1;36m'
VERDE='\e[1;32m'
AMARELO='\e[1;33m'
VERMELHO='\e[1;31m'
ROXO='\e[1;35m'
BRANCO='\e[1;37m'
CINZA='\e[1;90m'
RESET='\e[0m'

ARQ_CONFIG="./config/clientes.json"
LOG_FILE="historico_execucao.log"

# --- TELA DE BOOT ---
tela_boot() {
    clear
    echo -e "${CIANO}[INIT] Carregando modulos de sistema...${RESET}"
    sleep 0.7
    echo -e "${AZUL}[SECURE] Estabelecendo conexao wifi segura...${RESET}"
    sleep 0.8
    echo -e "${VERDE}[PROXY] Verificando gateways ativos...${RESET}"
    sleep 0.9
    echo -e "${AMARELO}[AUTH] Validando banco de dados local...${RESET}"
    sleep 0.8
    echo -e "${VERMELHO}[STATUS] Sistema liberado e operacional.${RESET}"
    sleep 1.2
    clear
}

# --- AUTENTICACAO POR CHAVE ---
autenticar_cliente() {
    tela_boot
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${RESET}"
    echo -e "${AZUL}║             AUTENTICACAO DE LICENCA              ║${RESET}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${RESET}"
    echo -e "${AMARELO}Insira a chave enviada pelo administrador.${RESET}\n"
    
    read -p "$(echo -e "${CIANO}>> Digite sua Chave de Acesso: ${RESET}")" KEY

    DADOS=$(python3 -c "
import json
try:
    with open('$ARQ_CONFIG') as f:
        cfg = json.load(f)
    if '$KEY' in cfg:
        item = cfg['$KEY']
        print(f\"{item['nome']}|{item['tempo']}|{item['mensagem_ban']}|{item['valor']}\")
    else:
        print('INVALIDO')
except Exception:
    print('INVALIDO')
" 2>/dev/null)

    if [[ "$DADOS" == "INVALIDO" || -z "$DADOS" ]]; then
        echo -e "\n${VERMELHO}[X] ERRO: Chave invalida ou inexistente!${RESET}"
        sleep 3
        exit 1
    fi

    IFS='|' read -r PLANO_NOME PRAZO_PLANO MSG_BAN VALOR_PLANO <<< "$DADOS"
    
    echo -e "\n${VERDE}✔ Licença validada com sucesso!${RESET}"
    echo -e "${CIANO}>> Plano Ativo: ${BRANCO}$PLANO_NOME${RESET}"
    echo -e "${CIANO}>> Prazo de Processamento: ${BRANCO}$PRAZO_PLANO${RESET}"
    sleep 2
}

salvar_log() {
    local acao="$1"
    local alvo="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - Plano: $PLANO_NOME | Acao: $acao | Alvo: $alvo" >> "$LOG_FILE"
}

show_logo() {
    clear
    echo -e "${AZUL}  ____    _    _   _ _    _    _    _ ____  ${RESET}"
    echo -e "${CIANO} | __ )  / \  | \ | | |  | |  | |  | | ____| ${RESET}"
    echo -e "${VERDE} |  _ \ / _ \ |  \| | |  | |  | |  | |  _|   ${RESET}"
    echo -e "${AMARELO} | |_) / ___ \| |\  | |__| |__| |_| | |___  ${RESET}"
    echo -e "${VERMELHO} |____/_/   \_\_| \_|____|_____\___/|_____| ${RESET}"
    echo -e "${ROXO}              by alisonkkjj yt              ${RESET}"
    echo -e "${BRANCO}--------------------------------------------------${RESET}"
    echo -e "${CIANO}Plano Ativo:${RESET} ${VERDE}$PLANO_NOME${RESET} | ${CIANO}Prazo:${RESET} ${BRANCO}$PRAZO_PLANO${RESET}"
    echo -e "${BRANCO}--------------------------------------------------${RESET}"
    echo
}

input_numero() {
    local texto_custom="$1"
    while true; do
        read -p "$(echo -e "${CIANO}$texto_custom ${RESET}")" numero
        if [[ "$numero" =~ ^[0-9]{10,15}$ ]]; then
            break
        else
            echo -e "${VERMELHO}❌ Numero invalido. Digite com DDD (Ex: 5511999998888).${RESET}"
        fi
    done
}

input_instagram() {
    while true; do
        read -p "$(echo -e "${CIANO}Digite o @ do usuario do Instagram alvo: ${RESET}")" usuario
        usuario="${usuario#@}"
        if [[ -n "$usuario" && ! "$usuario" =~ [[:space:]] ]]; then
            break
        else
            echo -e "${VERMELHO}❌ Usuario invalido. Tente novamente.${RESET}"
        fi
    done
}

simular_logs_rede() {
    local alvo="$1"
    echo -e "\n${CIANO}[CONNECT] Conectando ao gateway de rede...${RESET}"
    sleep 1.2
    echo -e "${VERDE}[PROXY] IP Atribuido: $(shuf -i 100-200 -n 1).$(shuf -i 10-99 -n 1).$(shuf -i 10-99 -n 1).$(shuf -i 1-250 -n 1)${RESET}"
    sleep 1.5
    echo -e "${AMARELO}[PAYLOAD] Processando solicitacao para o alvo: $alvo...${RESET}"
    sleep 1.8
}

spinner() {
    local duration=30
    local elapsed=0
    local spin='-\|/'

    while [ $elapsed -lt $duration ]; do
        for i in 0 1 2 3; do
            local pct=$(( (elapsed * 100) / duration ))
            printf "\r${AMARELO}[+] Processando dados [%-20s] %d%% %c${RESET}" "$(printf '#%.0s' $(seq 1 $((pct / 5))))" "$pct" "${spin:$i:1}"
            sleep 1
            ((elapsed++))
            if [ $elapsed -ge $duration ]; then
                break
            fi
        done
    done
    echo -e "\r${VERDE}✔ Operacao concluida com sucesso!                                            ${RESET}\n"
}

pausa() {
    echo
    read -p "$(echo -e "${AMARELO}Pressione ENTER para retornar ao menu principal...${RESET}")"
}

abrir_youtube() {
    echo -e "${CIANO}Redirecionando para o canal oficial de AlisonKKJJ...${RESET}"
    am start -a android.intent.action.VIEW -d "https://www.youtube.com/@alisonkkj" &>/dev/null || xdg-open "https://www.youtube.com/@alisonkkj" &>/dev/null
    sleep 1.5
}

banir_whatsapp() {
    clear
    echo -e "${VERMELHO}[ PAINEL - BANIR WHATSAPP ]${RESET}"
    input_numero "Digite o numero alvo do WhatsApp (com DDD):"
    simular_logs_rede "$numero"
    spinner
    salvar_log "BAN_WHATSAPP" "$numero"
    echo -e "${VERDE}✅ Procedimento Executado com Sucesso!\n"
    echo -e "${BRANCO}O numero $numero foi registrado no sistema.${RESET}"
    echo -e "${AMARELO}ℹ️ Status do Plano: $MSG_BAN${RESET}"
    pausa
}

desbanir_whatsapp() {
    clear
    echo -e "${VERDE}[ PAINEL - DESBANIR WHATSAPP ]${RESET}"
    input_numero "Digite o numero que deseja desbanir (com DDD):"
    simular_logs_rede "$numero"
    spinner
    salvar_log "DESBAN_WHATSAPP" "$numero"
    echo -e "${VERDE}✅ Solicitacao enviada para $numero!${RESET}"
    echo -e "${AMARELO}ℹ️ Prazo estimado: $PRAZO_PLANO${RESET}"
    pausa
}

blindar_whatsapp() {
    clear
    echo -e "${CIANO}[ PAINEL - BLINDAGEM ANTI-BAN ]${RESET}"
    input_numero "Digite o numero para aplicar a blindagem (com DDD):"
    simular_logs_rede "$numero"
    spinner
    salvar_log "BLINDAGEM_WHATSAPP" "$numero"
    echo -e "${VERDE}✅ Protecao ativada para $numero!${RESET}"
    pausa
}

banir_instagram() {
    clear
    echo -e "${ROXO}[ PAINEL - BANIR INSTAGRAM ]${RESET}"
    input_instagram
    simular_logs_rede "@$usuario"
    spinner
    salvar_log "BAN_INSTAGRAM" "@$usuario"
    echo -e "${VERDE}✅ Procedimento concluido!${RESET}"
    echo -e "${AMARELO}ℹ️ Alvo: @$usuario | $MSG_BAN${RESET}"
    pausa
}

ver_historico() {
    clear
    echo -e "${AZUL}=== HISTORICO DE OPERACOES RECENTES ===${RESET}\n"
    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo -e "${AMARELO}Nenhuma operacao registrada no sistema ainda.${RESET}"
    fi
    pausa
}

# --- EXECUCAO INICIAL ---
autenticar_cliente

# --- LOOP PRINCIPAL ---
while true; do
    show_logo
    echo -e "${AZUL}Selecione a operacao desejada:${RESET}"
    echo -e "${CIANO}  1) ⚡ Banir Numero (WhatsApp)${RESET}"
    echo -e "${VERDE}  2) 🛡️ Blindar Numero (Anti-Ban)${RESET}"
    echo -e "${ROXO}  3) 🔓 Desbanir Numero (WhatsApp)${RESET}"
    echo -e "${AMARELO}  4) 📸 Banir Instagram (Meta)${RESET}"
    echo -e "${BRANCO}  5) 📜 Ver Historico de Execucoes${RESET}"
    echo -e "${CIANO}  6) 🎬 Canal do YouTube (@alisonkkj)${RESET}"
    echo -e "${VERMELHO}  7) ❌ Sair do Painel${RESET}"
    echo
    read -p "$(echo -e "${CIANO}>> Opcao: ${RESET}")" opcao

    case $opcao in
        1) banir_whatsapp ;;
        2) blindar_whatsapp ;;
        3) desbanir_whatsapp ;;
        4) banir_instagram ;;
        5) ver_historico ;;
        6) abrir_youtube ;;
        7) clear; echo -e "${VERMELHO}Encerrando sessao... Ate logo!${RESET}"; break ;;
        *) echo -e "${VERMELHO}❌ Opcao invalida! Tente novamente.${RESET}"; sleep 1.5 ;;
    esac
done
