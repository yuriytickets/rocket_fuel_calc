### Rocket Fuel Calculator 🚀
- It is used to calculate fuel needed to launch/land a rocket using defined route

# Usage
From your terminal:
`ruby rocket.rb -h`
```
Usage: $> ruby rocket.rb [options]
    -m, --mass FLOAT                 Equipment Mass, Kg
    -r, --route ARR                  Route as launch,9.807,land,1.62
    -t, --test                       Test mode
```
🚀
# Example
`ruby rocket.rb -m 20000 -r launch,9.8,land,1.3`
```
🚀 20000.0 Kg
⛽︎Fuel needed: 15009.027049651544
```
