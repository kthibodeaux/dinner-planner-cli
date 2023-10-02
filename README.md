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

## example recipe

```toml
name = "Generic Dinner"
category = "Main"
include_in_cookbook = true
source = "My Great Cookbook p.12"
# text_size is in `em`. default is `1`
# text_size = 0.9

ingredients = [
  "Ingredients can be input here",
  "as an array.",
  "Use the following format",
  "14 oz can; Diced Tomatoes (do not drain)",
  "quantity; name (optional notes)",
  "quantity; name",
]

steps = [
  "Steps can be input here",
  "as an array.",
]

[groups.sauce]
name = "Sauce"

ingredients = [
  "For recipes that break steps apart",
  "special ingredients can be input here",
  "as an array.",
]

steps = [
  "For recipes that break steps apart",
  "special steps can be input here",
  "as an array.",
]

[groups.bread]
name = "Bread"

ingredients = [
  "For recipes that break steps apart",
  "special ingredients can be input here",
  "as an array.",
]

steps = [
  "For recipes that break steps apart",
  "special steps can be input here",
  "as an array.",
]
```
