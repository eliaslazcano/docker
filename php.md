# PHP: Construindo corretamente as imagens e containers

## Construir a imagem

#### Limpe o cache antes de construir imagens

`docker builder prune`

#### Construa a imagem partir do dockerfile

```bash
docker build --pull --rm -f "php.dockerfile" -t eliaslazcano/php:8.4.6-apache "."
```

> Entenda: `docker build --pull --rm -f "<nome_do_seu_arquivo>" -t <nome_da_imagem> "<caminho_do_arquivo>"`
>
> Se quiser enviar a imagem para o repositório do Dockerhub: `docker push eliaslazcano/php:8.4.6-apache`

## Preparativos antes de criar o container

#### Definir um local do disco para manter os arquivos .ini localmente (na máquina host)

```bash
docker run --rm -v ${PWD}/php:/backup eliaslazcano/php:8.4.6-apache sh -c "cp -ra /usr/local/etc/php/* /backup"
```

#### Gerar o php.ini sem os comentários

Vá até o diretório primeiro e depois faça:

```bash
grep -vE '^(;|[[:space:]]*$)' php/php.ini-production > php/php.ini
```

No windows:

```powershell
Get-Content php/php.ini-production | Where-Object { $_ -notmatch '^\s*(;|$)' } | Set-Content php/php.ini
```

## Criando o container

```bash
docker run -d --name=webapp --restart=always -p 8080:80 -v ${PWD}/php:/usr/local/etc/php -v ${PWD}/www:/var/www/html eliaslazcano/php:8.4.6-apache
```

> Você pode expor a porta **80** para ver o website, mas recomendo usar o Nginx para proxy reverso.
> 
> Aquele diretório dentro do container (/usr/local/etc/php) precisa estar ligado ao diretório local onde você alocou
> os arquivos **.ini**

## Turbinando o container PHP

#### Valores sugeridos no php.ini

Analise o arquivo principal `php.ini` e revise os valores como estão sendo mostrados abaixo:

```text
max_execution_time = 180
memory_limit = 256M
post_max_size = 256M
upload_max_filesize = 256M
```

#### Habilite o Jit

Ele torna o PHP mais performático, principalmente quando o código lida com muito processamento

Inclua alguns valores no arquivo .ini (do Opcache) dessa forma para habilitar o compilador JIT:

```bash
docker run --rm -v ${PWD}/php:/usr/local/etc/php eliaslazcano/php:8.4.6-apache sh -c "printf 'opcache.enable=1\nopcache.enable_cli=1\nopcache.jit=1235\nopcache.jit_buffer_size=64M\nopcache.memory_consumption=128' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini"
```

Pra você entender, o comando aplicou essa configuração no final do arquivo (ajuste como desejar):

```text
opcache.enable=1
opcache.enable_cli=1
opcache.jit=1235
opcache.jit_buffer_size=64M
opcache.memory_consumption=128
```

## Instalação de outros complementos

#### Wkhtmltopdf

```bash
# No debian 12 (64 bits) que atualmente é usado pela imagem PHP do Docker (8.3)
apt-get update
apt-get install wget -y
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb
dpkg -i wkhtmltox_0.12.6.1-3.bookworm_amd64.deb
apt-get install -f
```

#### QPDF

Consegue rápidamente unir documento e também comprimir, sem perder assinaturas, mas a compressão é muito fraca.

```bash
apt-get install qpdf
```

#### Poppler Utils

Consegue verificar se o documento PDF possui alguma assinatura digital

```bash
apt install poppler-utils
```

#### ghostscript

Comprime o documento PDF reduzindo o DPI das fotos, mas a custo de perder a assinatura digital.

```bash
apt install ghostscript poppler-utils
```