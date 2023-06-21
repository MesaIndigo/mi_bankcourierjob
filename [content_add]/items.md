-- Add these items to your data/items.lua file

    ----------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------
    -- G6 Security job
    ['phone_g6s'] = {
        label = 'G6S Work Phone',
        weight = 245,
        description = 'standard work phone for Gruppe Sech Security',
        stack = false,
        close = true,
        consume = 0,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'cellphone@', clip = 'cellphone_email_read_base' },
            prop = {
                model = 'prop_phone_ing',
                pos = { x = 0.0, y = 0.0, z = 0.0},
                rot = { x = 0.0, y = 0.0, z = 0.0}
            },
            usetime = 2500,
        }
    },
    
    ['bank_case'] = {
        label = 'Case of Money',
        weight = 245,
        description = 'a sizable case of money',
        stack = false,
        close = true,
    },
    
    ['bank_bag'] = {
        label = 'Bag of Money',
        weight = 245,
        description = 'a thicc bag of money',
        stack = false,
        close = true,
    }