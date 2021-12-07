# docker_ngx_small_light
最低限の設定だけ乗っけているので自己責任で使って下さい。ローカルでの動作は確認済みです。本番で使う方法が分かる方のプルリクお待ちしてます！！！！！！

## 利用方法

### 1. Dockerが入っているサーバーにログインする

### 2. 環境変数でドメインを指定する（下は例）

永続化出来るように注意して下さい

`echo export DOMAIN=****.com >> /etc/profile`

### 3. git clone
```bash
cd /usr/local
git clone https://github.com/ookam/docker_ngx_small_light.git
```

### 4. 起動
```bash
cd /usr/local/docker_ngx_small_light
docker build -t docker_ngx_small_light .
docker run docker_ngx_small_light
```

### その他
とりあえずこれで動くはずですが**動きません** ローカルなら動きます。Dockerよく分からん

# 使い方
細かいパラメータの指定方法は本家を見て下さい
https://github.com/cubicdaiya/ngx_small_light

画像の変換方法ですが、このDockerを動かすサーバーが`image.example.com`だとして、例えば `https://example.com/test.jpg` をカスタマイズしたい場合は以下のようなURLを作って下さい

`https://image.example.com/test.jpg?prox=example.com&dw=100`

大切なのは「pathはそのまま書く」「?prox=に元のドメインを書く」という点だけです
