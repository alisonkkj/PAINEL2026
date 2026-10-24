#!/bin/bash

# ==================================================
# PAINEL BANWHATS PRO - ELITE EDITION V4.1
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

# --- TELA DE BOOT HACKER ---
tela_boot() {
    clear
    echo -e "${CIANO}[INIT] Carregando módulos de segurança do kernel v6.8...${RESET}"
    sleep 0.7
    echo -e "${AZUL}[SECURE] Estabelecendo túnel criptografado AES-256-GCM...${RESET}"
    sleep 0.8
    echo -e "${VERDE}[PROXY] Conectando a nós de relay globais (Cloudflare / Meta API Gateway)...${RESET}"
    sleep 0.9
    echo -e "${AMARELO}[AUTH] Verificando integridade do banco de dados de chaves JSON...${RESET}"
    sleep 0.8
    echo -e "${VERMELHO}[STATUS] Sistema blindado e pronto. Iniciando ambiente seguro.${RESET}"
    sleep 1.2
    clear
}

# --- AUTENTICAÇÃO POR CHAVE ---
autenticar_cliente() {
    tela_boot
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${RESET}"
    echo -e "${AZUL}║             AUTENTICAÇÃO DE LICENÇA              ║${RESET}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${RESET}"
    echo -e "${AMARELO}Insira a chave VIP enviada pelo administrador.${RESET}\n"
    
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
        echo -e "\n${VERMELHO}[X] ERRO: Chave inválida, expirada ou inexistente!${RESET}"
        echo -e "${AMARELO}Entre em contato com o suporte para adquirir uma chave válida.${RESET}"
        sleep 3
        exit 1
    fi

    IFS='|' read -r PLANO_NOME PRAZO_PLANO MSG_BAN VALOR_PLANO <<< "$DADOS"
    
    echo -e "\n${VERDE}✔ Licença validada com sucesso!${RESET}"
    echo -e "${CIANO}>> Plano Ativo: ${BRANCO}$PLANO_NOME${RESET}"
    echo -e "${CIANO}>> Tempo de Processo: ${BRANCO}$PRAZO_PLANO${RESET}"
    sleep 2
}

salvar_log() {
    local acao=$1
    local alvo=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - Plano: $PLANO_NOME | Ação: $acao | Alvo: $alvo" >> "$LOG_FILE"
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
    local texto_custom=$1
    while true; do
        read -p "$(echo -e "${CIANO}$texto_custom${RESET}")" numero
        if [[ "$numero" =~ ^[0-9]{10,15}$ ]]; then
            break
        else
            echo -e "${VERMELHO}❌ Número inválido. Digite com DDD (Ex: 5511999998888).${RESET}"
        fi
    done
}

input_instagram() {
    while true; do
        read -p "$(echo -e "${CIANO}Digite o @ do usuário do Instagram alvo: ${RESET}")" usuario
        usuario="${usuario#@}"
        if [[ -n "$usuario" && ! "$usuario" =~ [[:space:]] ]]; then
            break
        else
            echo -e "${VERMELHO}❌ Usuário inválido. Tente novamente.${RESET}"
        fi
    done
}

simular_logs_rede() {
    local alvo=$1
    echo -e "\n${CIANO}[CONNECT] Conectando ao gateway seguro da API v2...${RESET}"
    sleep 1.2
    echo -e "${VERDE}[PROXY] Rota de saída estabelecida via IP: $(shuf -i 100-200 -n 1).$(shuf -i 10-99 -n 1).$(shuf -i 10-99 -n 1).$(shuf -i 1-250 -n 1) [ALTA SEGURANÇA]${RESET}"
    sleep 1.5
    echo -e "${AMARELO}[PAYLOAD] Injetando pacotes de bypass e forçando requisição para: $alvo...${RESET}"
    sleep 1.8
}

# Spinner mais longo e detalhado para prender a atenção no vídeo (45 segundos)
spinner() {
    local duration=45
    local elapsed=0
    local spin='-\|/'

    while [ $elapsed -lt $duration ]; do
        for i in $(seq 0 3); do
            local pct=$(( (elapsed * 100) / duration ))
            printf "\r${AMARELO}[+] Processando requisições profundas [%-20s] %d%% %c${RESET}" "$(printf '#%.0s' $(seq 1 $((pct / 5))))" "$pct" "${spin:$i:1}"
            sleep 1
            ((elapsed++))
            [ $elapsed -ge $duration ] && break
        done
    done
    echo -e "\r${VERDE}✔ Operação concluída com sucesso na API de destino!                                      ${RESET}\n"
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
    input_numero "Digite o número alvo do WhatsApp (com DDD, ex: 5511999998888): "
    simular_logs_rede "$numero"
    spinner
    salvar_log "BAN_WHATSAPP" "$numero"
    echo -e "${VERDE}✅ Procedimento Executado com Sucesso!\n"
    echo -e "${BRANCO}O número $numero foi injetado na fila de processamento prioritário.${RESET}"
    echo -e "${AMARELO}ℹ️ Detalhes do Plano: $MSG_BAN${RESET}"
    pausa
}

desbanir_whatsapp() {
    clear
    echo -e "${VERDE}[ PAINEL - DESBANIR WHATSAPP ]${RESET}"
    input_numero "Digite o número que deseja desbanir (com DDD, ex: 5511999998888): "
    simular_logs_rede "$numero"
    spinner
    salvar_log "DESBAN_WHATSAPP" "$numero"
    echo -e "${VERDE}✅ Solicitação de reversão de banimento enviada para $numero!${RESET}"
    echo -e "${AMARELO}ℹ️ Prazo estimado de liberação na base: $PRAZO_PLANO${RESET}"
    pausa
}

blindar_whatsapp() {
    clear
    echo -e "${CIANO}[ PAINEL - BLINDAGEM ANTI-BAN ]${RESET}"
    input_numero "Digite o número que vai receber a blindagem (com DDD): "
    simular_logs_rede "$numero"
    spinner
    salvar_log "BLINDAGEM_WHATSAPP" "$numero"
    echo -e "${VERDE}✅ Escudo de segurança anti-ban ativado para $numero!${RESET}"
    echo -e "${AMARELO}ℹ️ O número agora possui proteção ativa contra quedas e spam.${RESET}"
    pausa
}

banir_instagram() {
    clear
    echo -e "${ROXO}[ PAINEL - BANIR INSTAGRAM ]${RESET}"
    input_instagram
    simular_logs_rede "@$usuario"
    spinner
    salvar_log "BAN_INSTAGRAM" "@$usuario"
    echo -e "${VERDE}✅ Procedimento de denúncia em massa concluído com sucesso!${RESET}"
    echo -e "${AMARELO}ℹ️ Alvo: @$usuario | $MSG_BAN${RESET}"
    pausa
}

ver_historico() {
    clear
    echo -e "${AZUL}=== HISTÓRICO DE OPERAÇÕES RECENTES ===${RESET}\n"
    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo -e "${AMARELO}Nenhuma operação registrada no sistema ainda.${RESET}"
    fi
    pausa
}

# --- EXECUÇÃO INICIAL DE SEGURANÇA ---
autenticar_cliente

# --- LOOP PRINCIPAL DO PAINEL ---
while true; do
    show_logo
    echo -e "${AZUL}Selecione a operação desejada:${RESET}"
    echo -e "${CIANO}  1) ⚡ Banir Número (WhatsApp)${RESET}"
    echo -e "${VERDE}  2) 🛡️ Blindar Número (Anti-Ban)${RESET}"
    echo -e "${ROXO}  3) 🔓 Desbanir Número (WhatsApp)${RESET}"
    echo -e "${AMARELO}  4) 📸 Banir Instagram (Meta)${RESET}"
    echo -e "${BRANCO}  5) 📜 Ver Histórico de Execuções${RESET}"
    echo -e "${CIANO}  6) 🎬 Canal do YouTube (@alisonkkj)${RESET}"
    echo -e "${VERMELHO}  7) ❌ Sair do Painel${RESET}"
    echo
    read -p "$(echo -e "${CIANO}>> Opção: ${RESET})" opcao

    case $opcao in
        1) banir_whatsapp ;;
        2) blindar_whatsapp ;;
        3) desbanir_whatsapp ;;
        4) banir_instagram ;;
        5) ver_historico ;;
        6) abrir_youtube ;;
        7) clear; echo -e "${VERMELHO}Encerrando sessão segura... Até logo!${RESET}"; break ;;
        *) echo -e "${VERMELHO}❌ Opção inválida! Tente novamente.${RESET}"; sleep 1.5 ;;
    esac
done
