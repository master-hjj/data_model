from flask import Flask
from flask_migrate import Migrate, upgrade, migrate, init
from app import create_app, db

def run_migrations():
    # 创建应用实例
    app = create_app('development')
    migrate_obj = Migrate(app, db)

    # 初始化迁移目录（如果没有）
    with app.app_context():
        try:
            # 初始化迁移目录
            init(directory='migrations')
            print("Initialized migration directory.")
        except Exception as e:
            print(f"Migration directory already initialized or error occurred: {str(e)}")

        try:
            # 生成迁移脚本
            migrate(directory='migrations', message='Initial migration')
            print("Generated migration script.")
        except Exception as e:
            print(f"Error occurred while generating migration script: {str(e)}")

        try:
            # 应用迁移
            upgrade(directory='migrations')
            print("Applied migration to database.")
        except Exception as e:
            print(f"Error occurred while applying migration: {str(e)}")

if __name__ == '__main__':
    run_migrations()
