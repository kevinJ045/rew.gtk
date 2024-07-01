# Testing
To test you can first install `rew.gtk`.
```bash
npx @makano/rew@latest install github:kevinJ045/rew.gtk
```
Then:
```bash
npx @makano/rew@latest create -git my-test-gtk-app
cd my-test-gtk-app
```
In the `main.coffee` file, you can put:
```coffee
using namespace imp('rew.gtk',
  gtk: '4.0',
  package: packageName or app.config.manifest.package
).setup ->
  using JSX as Widget::create
  using refine(Window) ->
    hlo = @state 'Hello'
    <box>
      <text>{hlo}</text>
    </box>
```
Explanation:
+ First we imported the module
+ Then we initiated it by giving it attributes such as what gtk version we need and what the app package name is
+ Then we called setup, to give us a usage case to call our function
+ Next in the setup function we are using JSX, but with the `Widget::create` function that we get from our namespace.
+ Next, we use `refine(Window)` to strip all comma uses, but alternatively we can do `using Window, ->`.
+ And finally, we can make our app with jsx.

## More
To see more, look at the `test.coffee` and `test-imp.coffee` files.