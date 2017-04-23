db.createUser({
    user: "phalcon",
    pwd: "secret",
    roles: [
        {
            role: "root",
            db: "admin"
        }
    ]
});
