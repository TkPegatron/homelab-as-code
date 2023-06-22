# glauth

## App Configuration

Below are the decrypted versions of the sops encrypted toml files.

1. `server.sops.toml`
    ```toml
    debug = true
    [ldap]
        enabled = true
        listen = "0.0.0.0:389"
    [ldaps]
        enabled = false
    [api]
        enabled = true
        tls = false
        listen = "0.0.0.0:5555"
    [backend]
        datastore = "config"
        baseDN = "dc=int,dc=zynthovian,dc=xyz"
    ```

2. `groups.sops.toml`
    ```toml
    [[groups]]
        name = "svcaccts"
        gidnumber = 6500
    [[groups]]
        name = "admins"
        gidnumber = 6501
    [[groups]]
        name = "people"
        gidnumber = 6502
    ```

3. `users.sops.toml`
    ```toml
    [[users]]
        name = "search"
        uidnumber = 5000
        primarygroup = 6500
        passbcrypt = ""
        [[users.capabilities]]
            action = "search"
            object = "*"
    [[users]]
        name = "elliana"
        mail = "elliana.perry@gmail.com"
        givenname = "Elliana"
        sn = "Perry"
        loginShell = "/bin/zsh"
        uidnumber = 5001
        primarygroup = 6502
        othergroups = [ 6501 ]
        passbcrypt = ""
        sshkeys = [""]
        [[users.capabilities]]
            action = "search"
            object = "*"
    ```

For assigning passwords with bcrypt, the following python should do the trick:

```python
import bcrypt
import getpass
def hash_bcrypt(password):
    return bcrypt.hashpw(
        password.encode('utf-8'),
        bcrypt.gensalt(14)
    )

print(hash_bcrypt(getpass.getpass(prompt='Password: ', stream=None)).hex())
```