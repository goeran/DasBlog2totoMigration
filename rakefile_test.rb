#exec "Rake migrate_dasblog[/tests/data/dasblogThatDoesnotExist]"

exec "Rake migrate_dasblog[/tests/data/dasblog,/tests/data/toto,\"Gøran Hansen\"]"