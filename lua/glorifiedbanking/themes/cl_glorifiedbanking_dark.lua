
GlorifiedBanking.Themes.Register( "Dark", i18n.GetPhrase("gbDarkTheme"), {
    Colors = {
        backgroundCol = Color( 69, 69, 69 ),


        titleTextCol = Color( 255, 255, 255 ),
        titleBarCol = Color( 37, 161, 214 ),

        logoCol = Color( 255, 255, 255 ),
        logoBackgroundCol = Color( 46, 162, 212 ),

        backCol = Color( 255, 255, 255 ),
        backBackgroundCol = Color( 93, 93, 93 ),
        backBackgroundHoverCol = Color( 61, 61, 61 ),

        exitCol = Color( 255, 255, 255 ),
        exitBackgroundCol = Color( 208, 80, 84 ),
        exitBackgroundHoverCol = Color( 171, 64, 67 ),


        innerBoxBackgroundCol = Color( 55, 55, 55 ),
        innerBoxBorderCol = Color( 255, 255, 255 ),


        idleScreenMessageCol = Color( 69, 69, 69 ),


        loadingScreenBackgroundCol = Color( 49, 49, 49 ),
        loadingScreenBorderCol = Color( 46, 162, 212 ),
        loadingScreenTextCol = Color( 255, 255, 255 ),
        loadingScreenSpinnerCol = Color( 46, 162, 212 ),


        keyHoverCol = Color(0, 0, 0, 100),
        keyPressedCol = Color(0, 0, 0, 200)
    },
    Fonts = {
        ["ATMEntity.Title"] = {
            font = "Orbitron",
            size = 40,
            weight = 1000,
            antialias = true
        },
        ["ATMEntity.Loading"] = {
            font = "Montserrat",
            size = 60,
            weight = 500,
            antialias = true
        }
    },
    Materials = {
        logoSmall = Material( "glorified_banking/logo_small.png", "noclamp smooth" ),
        back = Material( "glorified_banking/back.png", "noclamp smooth" ),
        exit = Material( "glorified_banking/exit.png", "noclamp smooth" ),
        circle = Material( "glorified_banking/circle.png", "noclamp smooth" ),
        cursor = Material( "glorified_banking/cursor.png", "noclamp smooth" ),
        cursorHover = Material( "glorified_banking/cursor_hover.png", "noclamp smooth" ),
        bankCard = Material( "shitcardlol.png", "noclamp smooth" )
    }
} )
