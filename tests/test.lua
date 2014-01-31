
        require "lunit.lunitx"

        module( "my_testcase", lunit.testcase, package.seeall )

        function FirstTest()
          -- Test code goes here
					assert("aa"=="bb", "aa rovná se bb")
        end

        function test_something()
            -- Test code goes here
						assert(1==1,"jedna rovná se jedna")
        end
