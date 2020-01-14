# rOpenserver 

## 0.1.0.9005
* Stick to R6 style for initialization `OpenServer$new()`
* Improve unit tests
* Copy models for testing
* Do not test R6 to S3 methods 


## 0.1.0.9004
* After copying the example in `README` to a unit test, getting this error when using this form of `DoCmd` and `DoGet`: `DoCmd(prosper_server, open_cmd)`.Where is the problem?


```
> library(rOpenserver)
> 
> test_check("rOpenserver")
-- 1. Error: README code behaves the same in tests (@test_readme.R#26)  --------------------------------------
object 'open_cmd' not found
Backtrace:
 1. R62S3:::DoCmd(prosper_server, open_cmd)
 4. private$get_app_name(command)
 5. base::toupper(string_value)
```

This form of command works in the **README** but fails in the unit tests. Why?

Addin `object` to the method in the `OpenServer` class doesn't help either; it is just redundant because the `object` is implied.

* Recompiling `testthat` from source
* Add simple test to check `DoCmd` works. It doesn't. Still getting error at the unit test.

## 0.1.0.9003

* Documenting function `setOpenServer` that acts as a OpenServer constructor. 


## 0.1.0.9002
* trying with different option to obtaina constructor of `OpenServer` without using `OpensServer$new()`. Attempts unsuccesful witout sacrificing documentation, and renaming main class to `.OpenServer`, that is *dot OpenServer*
* Added a `NEWS.md` file to track changes to the package.


## 0.1.0.9000
* The original `openserver` package works fine but didn't have any roxygen2 documentation.

