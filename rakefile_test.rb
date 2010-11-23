# coding: utf-8
#exec "Rake migrate_dasblog[/tests/data/dasblogThatDoesnotExist]"
exec "Rake migrate_dasblog[/specs/data/dasblog,/specs/data/toto,\"Gøran Hansen\"] --trace"