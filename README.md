## Instruções de Uso

### 1. Configuração Inicial

Verifique o arquivo `.env` para definir senhas, versões e demais ajustes conforme necessário.

### 2. Instalação

Execute o script de instalação com o comando:

```bash
bash instalar.sh
```

### 3. Migração de Sites (Opcional)

Se estiver migrando seus sites de outro servidor, utilize o comando abaixo:

```bash
rsync -avz -e "ssh -i ~/ssh_ubuntu.pem" ubuntu@172.31.20.226:/home/ubuntu/docker/www/ "$(pwd)/sites"
```

### 4. Alterar a Versão do PHP (Opcional)

Caso deseje utilizar outra versão do PHP:

- Altere as referências à versão no arquivo `instalar.sh` e no `./php/Dockerfile`.
- Opcionalmente, edite o nome da imagem gerada no arquivo `docker-compose.yml`.

### Parando a Stack

```bash
docker compose stop
```
