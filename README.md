# Connect Announcer
Simple & **lightweight** SourceMod plugin to announce (or to not announce) player & staff connects/disconnects. Most of the dozens of available connect/disconnect announcers are bad, and this one probably is too - it just happens to fit our community's needs.

Aside from a standardized and customizable connect and disconnect message (see translations), we found it prudent to have an easy switch for enabling and disabling connect/disconnect messages for our staff team. This is especially handy for responding to calladmins to catch rule breakers without giving them a heads up of connecting staff, or letting everyone know that "hey the admin is gone, let's act up now". This plugin allows admins to still view disconnects of all players and their fellow staff if you so choose.

## ConVars
`sm_cannouncer_connect_enable` - Enable (1)/Disable (0) connect messages  
`sm_cannouncer_disconnect_enable` - Enable disconnect messages for admins only - 2, Enable disconnect messages for everyone - 1, Disable disconnect messages - 0  
`sm_cannouncer_admin_connect` - Show message of an admin connecting - 1, Suppress message - 0  
`sm_cannouncer_admin_disconnect` - Show message of an admin disconnecting - 1, Suppress message - 0  

## Notes
Written using [GeoIP2 extension](https://forums.alliedmods.net/showthread.php?t=311477) in mind (included)
Full translations support
Utilizes [ColorLib](https://github.com/c0rp3n/colorlib-sm)
