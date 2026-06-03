import json

def to_sexpr(data):
    if isinstance(data, dict):
        # 字典转换为 Association List: ((key . value) (key2 . value2))
        items = [f"({k} . {to_sexpr(v)})" for k, v in data.items()]
        return "(" + " ".join(items) + ")"
    elif isinstance(data, list):
        # 列表转换为普通 List: (item1 item2 item3)
        return "(" + " ".join(to_sexpr(item) for item in data) + ")"
    elif isinstance(data, bool):
        return "#t" if data else "#f"
    elif data is None:
        return "'()"
    elif isinstance(data, str):
        # json.dumps 会自动处理字符串里的引号和转义符，非常安全
        return json.dumps(data)
    else:
        # 处理数字等
        return str(data)

# 读取你提供的 json
with open('raylib_api.json', 'r', encoding='utf-8') as f:
    j = json.load(f)

# 输出为 Scheme 脚本可以直接 read 的数据文件
with open('raylib_api.ss', 'w', encoding='utf-8') as f:
    f.write(to_sexpr(j))

print("转换完成！生成了 raylib_api.ss")
