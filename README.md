# CRYPTOBOT
  the best crypto bot in the market


# App testing
  - the facebook APP is not Live, since it requires to have a business account and then go to a review process
  in order to get the `pages_messaging` scope to be approved. so in order for the other people to test it, they need
  to be included as an app tester on facebook.

# Demo
  ![replay](./replay.gif)

 ## Running Locally
    ### Pre requisites
      1. docker
      2. make
      ### Steps
        1. run `make db-create
        2. run `make start`


# Patterns/Architectures used
  - ## Mocks
    - By Separating the main API modules: `cryptobot_web/services/api/*_api.ex` to the module that executes them: `cryptobot_web/services/api/*api_service.ex`. I can easily setup mocks `test/crypto_web/mocks/*_mocks.ex` to be used on testing them. It ensures that the only thing I'm testing is my code and not the 3rd party API's.

  - ## Delegators
    - I'll be honest that I'm not sure what this pattern is called �, but I'll call it as a "DELEGATOR" since it delegates the proper module. you can see its implementation at `cryptobot_web/services/api/crypto_market/crypto_market.ex`. that delegator module allows us to easily implement other 3rd party crypto market API's. all we need to make sure is for them to behave the same way when implementing them, And the 3rd pattern i've used: `BEHAVIOURS` 

# Code structuring
  ```
  this allows us in the future to organize all the webhooks to a single folder

   Controllers
    |- Webhooks
      - facebook_controller.ex
  ```

  ```
    CryptobotWeb
      |- Services
        |- Api (put all 3rd party API implementation here)
          - *3rdPartyapi*_api.ex (implements the HTTPoisoin.Base for setting up headers and for encoding and decoding the request and response bodies)
          |- *GenericTermForthe3rdPartyApi (ex: PaymentGateways for Paypal/Stripe etc)
            - *genericterm.ex (implements the Delegator pattern)
            - *3rdpartyapi.ex (implements the API module. responsible for building the request parameters and bodies and handling the response)
            - *genericterm_behaviour.ex (implements the behaviour callbacks that all the API module should implement)

          |- facebook
            - event_handler.ex (handles the pattern matching for all of the incoming facebook webhook events)
            - facebook.ex (responsible for building request bodiesand handling the response from facebook)
            - templates.ex (responsible for building the JSON payload for the response to be sent on facebook)
  ```

## Test Coverage

![Screenshot](/test-coverage.png)

