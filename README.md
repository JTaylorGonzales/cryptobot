# CRYPTOBOT
 ## the best crypto bot in the market

# Patterns/Architectures used
  - ## Mocks
    - By Separating the main API modules: `cryptobot_web/services/api/*_api.ex` to the module that executes them: `cryptobot_web/services/api/*api_service.ex`. I can easily setup mocks `test/crypto_web/mocks/*_mocks.ex` to be used on testing them. It ensures that the only thing I'm testing is my code and not the 3rd party API's.

  - ## Delegators
    - I'll be honest that I'm not sure what this pattern is called �, but I'll call it as a "DELEGATOR" since it delegates the proper module. you can see its implementation at `cryptobot_web/services/api/crypto_market/crypto_market.ex`. that delegator module allows us to easily implement other 3rd party crypto market API's. all we need to make sure is for them to behave the same way when implementing them, And the 3rd pattern i've used: `BEHAVIOURS` 



## Test Coverage

![Screenshot](/test-coverage.png)

