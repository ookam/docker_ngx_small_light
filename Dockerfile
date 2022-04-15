FROM fabiocicerchia/nginx-lua:1.21.4-debian
ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/conf.d/default.conf /etc/nginx/conf.d/default.conf
RUN mkdir /var/cache/nginx/proxy_file_cache

# ↓ デフォルトのarchive.ubuntu.comは遅いので日本の高速なサーバーに置き換える
# エラーが出る場合はコメントアウトして下さい
RUN sed -i.org -e 's|archive.ubuntu.com|ubuntutym.u-toyama.ac.jp|g' /etc/apt/sources.list
RUN apt update -y

# 言語設定を行う
RUN apt install -y --no-install-recommends locales
RUN locale-gen en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# ngx_small_lightの導入
RUN apt install -y --no-install-recommends \
    make \
    build-essential \
    imagemagick \
    libmagickwand-dev \
    libimlib2-dev \
    libgd-dev \
    libssl-dev \
    libxslt-dev \
    git


RUN cd /tmp && \
    curl -O http://nginx.org/download/nginx-1.21.4.tar.gz && \
    tar xzvf nginx-1.21.4.tar.gz && \
    cd nginx-1.21.4 && \
    git clone https://github.com/cubicdaiya/ngx_small_light && \
    cd ngx_small_light && \
    ./setup --with-gd --with-imlib2 && \
    cd .. && \
    ./configure --add-dynamic-module=./ngx_small_light \
                --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' && \
    make modules && \
    cp objs/ngx_http_small_light_module.so /etc/nginx/

# 追記↓これがあると一生エラーになる問題が発生したのでコメントアウト
# 正直理由はよく分かっていないのでわかる人いたら教えてください
# CMD ['/usr/sbin/nginx', '-g', '"daemon off;"', '-c', '/etc/nginx/nginx.conf']
# /usr/sbin/nginx -g "daemon off;" -c /etc/nginx/nginx.conf
