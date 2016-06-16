# TextMate Bundle for GitHub's Redcarpet Markdown

First, put this bundle in your TextMate bundle directory:

```bash
# Textmate2
mkdir -p ~/Library/Application\ Support/Avian/Bundles/
cd ~/Library/Application\ Support/Avian/Bundles/
git clone https://github.com/streeter/markdown-redcarpet.tmbundle.git

# Then, make sure you've got `redcarpet` and `pygments.rb`
# installed with your gem library with system's Ruby 1.8:
unset GEM_HOME
unset GEM_PATH

sudo /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/gem install redcarpet -v 2.3.0
sudo /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/gem install pygments.rb
```

![Redcarpet Markdown Bundle in action](http://cl.ly/image/1Y071W2A2l1w/Screen%20Shot%202014-02-18%20at%2011.02.32%20am.png)


### Supported syntaxes inside fenced blocks

The following syntaxes will be highlighted inside the fenced block:

- Ruby
- Javascript (as js, javascript)
- CoffeeScript (as coffee, coffeescript)
- Shell (as shell, bash, sh)
- Haml
- R
- C, C++
- YAML



**Bonus** [Install the **Scott Web Theme** from *Preferences → Bundles*](https://raw.github.com/streeter/markdown-redcarpet.tmbundle/master/theme-preview-scott.png) for a nice looking preview

Reload TextMate and tell it to read `.md` files as Markdown Redcarpet types.

For more information about GitHub's Redcarpet markdown, [checkout this post][github-flavored-markdown].


[github-flavored-markdown]: http://github.github.com/github-flavored-markdown/
[github-theme]: https://github.com/kneath/github_textmate_preview

## R Markdown

This bundle also supports [R Markdown](http://www.rstudio.com/ide/docs/r_markdown) files (Rmd, rmd) by properly scoping fenced [R code](http://cran.r-project.org/) chunks and inline R code to the R source syntax when used with the [R TextMate bundle](https://github.com/textmate/r.tmbundle). You can then use the commands from the [R TextMate bundle](https://github.com/textmate/r.tmbundle) to evaluate R code, send it to the R GUI, etc. This bundle includes two commands to _knit_ R Markdown files and produce the HTML result: one uses the [knitr](http://cran.r-project.org/web/packages/knitr/index.html) package while the other one (recommended, see why [here](http://lcolladotor.github.io/2013/12/10/knitrBootstrap/)) uses the [knitrBootstrap](http://cran.at.r-project.org/web/packages/knitrBootstrap/index.html) package.

For R noweb files (Rnw, rnw) you might be interested in the [knitr TextMate bundle](https://github.com/fonnesbeck/knitr.tmbundle) which bridges LaTeX and R code.
