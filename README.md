# dinner-planner-cli

A command line recipe manager, dinner planner, and shopping list generator.

## setup

To install:

```
gem uninstall dinner-planner-cli
rm *.gem
gem build dinner-planner-cli.gemspec
gem install dinner-planner-cli*.gem
```

## usage

Create a directory for your recipes, and `cd` in to it. Run any `dinner-planner` command. Running any command that requires a config file will create an empty config file before running.
