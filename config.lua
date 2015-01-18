--calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
   content = {
      width = aspectRatio > 1.5 and 320 or math.ceil( 480 / aspectRatio ),
      height = aspectRatio < 1.5 and 480 or math.ceil( 320 * aspectRatio ),
      scale = "letterBox",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.5,
         ["@4x"] = 3.0,
      },
   },
   SpriteHelperSettings = 
        {
          imagesSubfolder = "Images",
        },
        license =
        {
          google =
          {
            key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAozSHdJRUEujwAGWx7ucEF0ajfEVbIxF66j2nv1SU5UeRm17FReg2uKZ4YVYn7vrIQwEZmdZWvfjJ/YoUpK8R7Q6AyS0gb/AlwL5871UsqrCpiQhL0wkfpkvd9swkGTlvhqNSPYYwnlZiuTx+v8JWf+wpQ9h7PSAoFVzvkUH54sG1VYa8ZkdQegHm0lynYALM3Xg3Ko/Bhu2ZJ7wYPHvEPKubF0gHahwBppJmfLyx0WBzU4PCdb53H2lT7xQO2FCacfLNc2jl1r3f4NBQQ1Kege4ndsBhPnwTYInrkz6k7FqR5hQxVKIxL5G46n5+hY2a2YNJACvxf59JtaUAYbfekQIDAQAB",
            policy = "serverManaged",
          },
        }
}


-- if string.sub(system.getInfo("model"),1,4) == "iPad" then
--     application = 
--     {
--         content =
--         {
--             width = 360,
--             height = 480,
--             scale = "letterbox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--         SpriteHelperSettings = 
-- 		{
-- 			imagesSubfolder = "Images",
-- 		},
--         notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                 }
--             }
--         }
--     }

-- elseif string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight > 960 then
--     application = 
--     {
--         content =
--         {
--             width = 320,
--             height = 568,
--             scale = "letterbox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--         SpriteHelperSettings = 
-- 		{
-- 			imagesSubfolder = "Images",
-- 		},
--         notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                 }
--             }
--         }
--     }

-- elseif string.sub(system.getInfo("model"),1,2) == "iP" then
--     application = 
--     {
--         content =
--         {
--             width = 320,
--             height = 480,
--             scale = "letterbox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--         SpriteHelperSettings = 
-- 		{
-- 			imagesSubfolder = "Images",
-- 		},
--         notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                 }
--             }
--         }
--     }
-- elseif display.pixelHeight / display.pixelWidth > 1.72 then
--     application = 
--     {
--         content =
--         {
--             width = 320,
--             height = 570,
--             scale = "letterbox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--         SpriteHelperSettings = 
--         {
--           imagesSubfolder = "Images",
--         },
--         license =
--         {
--           google =
--           {
--             key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAozSHdJRUEujwAGWx7ucEF0ajfEVbIxF66j2nv1SU5UeRm17FReg2uKZ4YVYn7vrIQwEZmdZWvfjJ/YoUpK8R7Q6AyS0gb/AlwL5871UsqrCpiQhL0wkfpkvd9swkGTlvhqNSPYYwnlZiuTx+v8JWf+wpQ9h7PSAoFVzvkUH54sG1VYa8ZkdQegHm0lynYALM3Xg3Ko/Bhu2ZJ7wYPHvEPKubF0gHahwBppJmfLyx0WBzU4PCdb53H2lT7xQO2FCacfLNc2jl1r3f4NBQQ1Kege4ndsBhPnwTYInrkz6k7FqR5hQxVKIxL5G46n5+hY2a2YNJACvxf59JtaUAYbfekQIDAQAB",
--             policy = "serverManaged",
--           },
--         },
--     }
-- else
--     application = 
--     {
--       content =
--         {
--             width = 320,
--             height = 512,
--             scale = "letterbox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--       SpriteHelperSettings = 
--         {
--           imagesSubfolder = "Images",
--         },
--       notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                     }
--                 }
--         },
--       license =
--         {
--           google =
--             {
--               key =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAozSHdJRUEujwAGWx7ucEF0ajfEVbIxF66j2nv1SU5UeRm17FReg2uKZ4YVYn7vrIQwEZmdZWvfjJ/YoUpK8R7Q6AyS0gb/AlwL5871UsqrCpiQhL0wkfpkvd9swkGTlvhqNSPYYwnlZiuTx+v8JWf+wpQ9h7PSAoFVzvkUH54sG1VYa8ZkdQegHm0lynYALM3Xg3Ko/Bhu2ZJ7wYPHvEPKubF0gHahwBppJmfLyx0WBzU4PCdb53H2lT7xQO2FCacfLNc2jl1r3f4NBQQ1Kege4ndsBhPnwTYInrkz6k7FqR5hQxVKIxL5G46n5+hY2a2YNJACvxf59JtaUAYbfekQIDAQAB",
--               policy = "serverManaged",
--             },
--         },
--   }
-- end
