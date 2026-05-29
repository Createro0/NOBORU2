NOBORU2 TEST - PARSER FIX

PROBLEMAS RESOLVIDOS:
- Main.lua agora carrega parsers de app0:assets/parsers/ automaticamente
- nhentai parser agora funciona sem precisar copiar manualmente
- Sistema de parsers agora suporta carregamento duplo (built-in + usuario)

O QUE FOI MUDADO:
1. main.lua foi atualizado para carregar parsers de duas localizacoes:
   - app0:assets/parsers/ (parsers inclusos no VPK)
   - ux0:data/noboru/parsers/ (parsers instalados pelo usuario)

COMO USAR:
1. Instalar NOBORU2-test.vpk via VitaShell
2. Abrir NOBORU 2
3. Ir em Settings -> NSFW = ON
4. Ir em Catalog -> nhentai ja deve estar disponivel

INSTALACAO MANUAL DE PARSERS (opcional):
- Para adicionar mais parsers, copiar .lua files para:
  ux0:data/noboru/parsers/

NOTAS:
- nhentai usa imagens .webp que podem nao renderizar perfeitamente em versoes antigas
- Se tiver problemas, limpar cache em Settings -> Data Management

DATA: 2026-05-28
