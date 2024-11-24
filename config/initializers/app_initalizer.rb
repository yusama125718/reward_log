# adminのアカウントがない場合は作成する
# User.create(name: "admin", password: "admin", permission: "admin") if User.where(permission: "admin").exists?