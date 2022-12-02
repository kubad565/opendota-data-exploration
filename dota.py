import opendota

# Initialize the API-connection object
client = opendota.OpenDota()
connect = client.get("/scenarios/misc")
print(connect)
with open('out.txt', 'w', encoding="utf-8") as f:
    print(connect, file=f)  