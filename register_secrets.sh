#!/bin/bash

# GitHubシークレット自動登録スクリプト
# 使い方: ./register_secrets.sh secrets.txt

if [ $# -eq 0 ]; then
    echo "使い方: $0 <secrets_file>"
    exit 1
fi

secrets_file="$1"

if [ ! -f "$secrets_file" ]; then
    echo "ファイルが見つからない: $secrets_file"
    exit 1
fi

echo "GitHubシークレット登録開始: $secrets_file"
echo "==========================================="

# ファイルを1行ずつ読んで処理
while IFS='=' read -r key value; do
    # 空行やコメント行をスキップ
    if [[ -z "$key" || "$key" =~ ^# ]]; then
        continue
    fi
    
    # 前後の空白を削除
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    if [[ -n "$key" && -n "$value" ]]; then
        echo "登録中: $key"
        gh secret set "$key" --body "$value"
        
        if [ $? -eq 0 ]; then
            echo "✓ $key 登録完了"
        else
            echo "✗ $key 登録失敗"
        fi
        echo "---"
    fi
done < "$secrets_file"

echo "==========================================="
echo "全てのシークレット登録処理完了"
echo ""
echo "登録されたシークレット一覧:"
gh secret list