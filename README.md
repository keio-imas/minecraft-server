# K-m@s Minecraft Server

K〼公式Minecraft Serverの構成ファイル集です．

## Requirements

- Docker

## How to Use

### 1. Make `.env` File

`.env.example`を参考にして，`.env`ファイルを作成してください．

### 2. Build Docker Image

```bash
docker compose up --build -d
```

### 3. Access the Server

Minecraft Clientから`{IP}:{PORT}`でアクセスしてください．

### 4. (Optional) ddclient Setup

Cloudflareを用いたDDNSを利用する場合，`ddclient`の設定を`ddclient/ddclient.conf.example`を参考に実行してください．

### Quitting the Server

```bash
docker compose down
```

# License

[MIT License](https://opensource.org/licenses/MIT)
