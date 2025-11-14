#!/bin/bash

# Script para compilar OTClient para Windows usando Docker

set -e

echo "════════════════════════════════════════════════════════════════"
echo "  COMPILANDO OTCLIENT PARA WINDOWS"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Diretório atual
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$HOME/Desktop/Compartilhado/Compilacoes/otclient-windows"

echo -e "${BLUE}📁 Diretório do projeto:${NC} $SCRIPT_DIR"
echo -e "${BLUE}📦 Pasta de saída:${NC} $OUTPUT_DIR"
echo ""

# Criar pasta de saída se não existir
mkdir -p "$OUTPUT_DIR"

echo -e "${BLUE}🐳 Construindo imagem Docker...${NC}"
docker build -t otclient-windows-builder -f Dockerfile.windows "$SCRIPT_DIR"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Imagem Docker construída com sucesso!${NC}"
    echo ""
else
    echo -e "${RED}❌ Erro ao construir imagem Docker${NC}"
    exit 1
fi

echo -e "${BLUE}⚙️  Compilando OTClient para Windows...${NC}"
echo -e "${BLUE}   (Isso pode demorar alguns minutos)${NC}"
echo ""

docker run --rm \
    -v "$OUTPUT_DIR:/output" \
    otclient-windows-builder

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Compilação concluída com sucesso!${NC}"
    echo ""
    echo -e "${GREEN}📦 Executável disponível em:${NC}"
    echo -e "   $OUTPUT_DIR/otclient.exe"
    echo ""
    
    if [ -f "$OUTPUT_DIR/otclient.exe" ]; then
        SIZE=$(du -h "$OUTPUT_DIR/otclient.exe" | cut -f1)
        echo -e "${GREEN}📊 Tamanho:${NC} $SIZE"
    fi
    
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo -e "${GREEN}  PRONTO PARA USAR NO WINDOWS!${NC}"
    echo "════════════════════════════════════════════════════════════════"
else
    echo ""
    echo -e "${RED}❌ Erro durante a compilação${NC}"
    exit 1
fi

