# iceberg-sandbox-kit

Trino, Iceberg の学習用リポジトリです。

- docker compose 構成
  - Trino
  - Iceberg REST Catalog
  - MySQL (REST Catalog 用)
  - MinIO (Iceberg メタデータ・データ用)
  - デバッグ用コンテナ
- 動作環境
  - Linux
  - Docker v20.10 以降
  - make

## 1. Setup

主なスクリプトは Makefile に記述されています。
make コマンドもしくは、コマンドのコピーペーストで実行してください。

```bash
$ git clone git@github.com:kamijin-fanta/iceberg-sandbox-kit.git
$ cd iceberg-sandbox-kit
$ make
```

`make` を実行することで、コンテナが起動します。

## 2. Insert data in Trino

`make trino` で Trino の CLI が起動します。最初にスキーマ定義を行い、その後にデータを挿入します。

```bash
$ make trino  # trino cliが起動

trino> show schemas;
```

```sql
-- 最初だけスキーマ定義が必要
CREATE SCHEMA default;
USE default;

CREATE TABLE t1 (a int, b int);
INSERT INTO t1 VALUES (1, 2);
SELECT * FROM t1;
```

## 3. Query catalog

REST Catalog のバックエンドである MySQL に、どんな情報が保存されているかを確認します。

```bsah
$ make mysql  # mysql cliが起動

mysql> show tables;
mysql> select * from iceberg_tables;
```

## 4. Explore inside object storage

Iceberg は、データをオブジェクトストレージに保存します。
今回の構成ではストレージに MinIO を使用しています。

デバッグ用コンテナの `/mnt/s3` 以下に MinIO のデータが s3fs でマウントされています。
Iceberg で利用される主なフォーマットである、JSON,Avro,Parquet などのフォーマットを開くためのコマンド jq,avrocat,pqrs もインストール済みです。

```bash
$ make debug  # デバッグ用コンテナが起動

root@debug:/mnt/s3# tree
root@debug:/mnt/s3# jq '.' default/t1-XXXX/metadata/0000X-XXXX.metadata.json
root@debug:/mnt/s3# avrocat default/t1-XXXX/metadata/snap-XXXX.avro | jq '.'
root@debug:/mnt/s3# duckdb -c "SELECT * FROM 'default/t1-XXXX/data/2025....XXXX.parquet'"
```

## 5. View the MitM Proxy logs

Trino がオブジェクトストレージにアセスする際、man-in-the-middle proxy を介するよう構成しています。
WebUI からアクセス内容が確認できます。

http://localhost:8081/

## 6. Optimize

`make trino` で CLI を開いていくつかのデータを Insert したあと、以下のような最適化コマンドでメタデータ・データがどう変化するかを確認します。

```sql
ALTER TABLE t1 EXECUTE optimize(file_size_threshold => '10MB');
ALTER TABLE t1 EXECUTE expire_snapshots(retention_threshold => '7d');
ALTER TABLE t1 EXECUTE remove_orphan_files(retention_threshold => '7d');
```

## 7. Cleanup

最後は、コンテナ・保存領域を削除します。

```bash
$ make clean
```

## 8. Enjoy!

以上で、Iceberg と Trino の学習環境が整いました。
