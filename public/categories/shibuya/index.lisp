<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en-us">
    <head>
        
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1" />

        <title>Shibuya.Lisp | κeenのHappy Hacκing Blog</title>
        <link rel="stylesheet" href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600' type='text/css' />
        <link rel="stylesheet" href="/libraries/normalize.3.0.1.css" />
        <link rel="stylesheet" href="/css/liquorice.css" />
        <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
        <link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
        <link rel="manifest" href="/manifest.json">
        <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
        <meta name="theme-color" content="#ffffff">
        <link rel="apple-touch-icon-precomposed" href="/apple-touch-icon-144-precomposed.png" sizes="144x144" />
        <link rel="alternate" href="/categories/shibuya.lisp/index.xml" type="application/rss+xml" title="κeenのHappy Hacκing Blog" />
        
        <script>
         (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
             (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                                  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
         })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

         ga('create', 'UA-43779888-1', 'auto');
         ga('send', 'pageview');

        </script>
        
        <link rel="stylesheet" href="/highlight.js/styles/xcode.css" />
<script src="/highlight.js/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({ tex2jax: { inlineMath: [['$','$'], ["\\(","\\)"]] } });
</script>
<script async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS_CHTML"></script>
</script>
<meta http-equiv="X-UA-Compatible" CONTENT="IE=EmulateIE7" />

    </head>
    <body class="li-body">

<header class="li-page-header" id="page-header">
    <div class="container">
        <div class="row">
            <div class="sixteen columns">
                <div class="li-brand li-left">
                <a href="/">κeenのHappy Hacκing Blog</a> | Lispエイリアンの狂想曲</div>
                <div class="li-menu li-right">
                    <span class="li-menu-icon" onclick="javascript:toggle('menu');">&#9776;</span>
                    <ul id="menu2" class="li-menu-items">
                        
                            <li><a href="/about/"> About </a></li>
                        
                            <li><a href="/index.xml"> Atom </a></li>
                        
                            <li><a href="/post/"> Blog </a></li>
                        
                            <li><a href="/slide/"> Slide </a></li>
                        
                    </ul>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="sixteen columns">
                <ul id="menu" class="li-menu-items li-menu-mobile">
                    
                        <li><a href="/about/"> About </a></li>
                    
                        <li><a href="/index.xml"> Atom </a></li>
                    
                        <li><a href="/post/"> Blog </a></li>
                    
                        <li><a href="/slide/"> Slide </a></li>
                    
                </ul>
            </div>
        </div>
    </div>
</header>


    <div class="container">
        <div class="row">
            <div class="sixteen columns">
                <style>
                 .li-rss:hover:after{content:'を購読する';font-size: 30%}
                </style>
                <h1 class="li-rss"><a href="/categories/shibuya/index.lisp/index.xml">Shibuya.Lisp</a></h1>
                <ul class="li-article-list">
                    
                    <li>
                        <h4><a href="/blog/2014/09/16/lisp-tech-talk-8">Shibuya.lisp Tech Talk #8を運営&amp;LTしてきました</a></h4>
                        <div class="li-article-meta">
    <time class="li-article-date">2014-09-16</time>
    <ul class="li-article-tag">
    
        <li>
            <a href="/categories/shibuya.lisp">Shibuya.lisp</a>
        </li>
    
        <li>
            <a href="/categories/lisp">Lisp</a>
        </li>
    
        <li>
            <a href="/categories/common-lisp">Common Lisp</a>
        </li>
    
        <li>
            <a href="/categories/mocl">mocl</a>
        </li>
    
        <li>
            <a href="/categories/android">Android</a>
        </li>
    
</ul>

</div>

                    </li>
                    
                </ul>
            </div>
        </div>
    </div>

<footer class="li-page-footer">
    <div class="container">
        <div class="row">
            <div class="sixteen columns">
                <div class="li-page-footer-legal">
                    &copy; 2017. All rights reserved. 
                </div>
                <div class="li-page-footer-theme">
                    <span class=""><a href="https://github.com/eliasson/liquorice/">liquorice</a> is a theme for <a href="http://hugo.spf13.com">hugo</a></span>
                </div>
            </div>
        </div>
    </div>
</footer>

    <script type="text/javascript">
    <!--
    function toggle(id) {
        var e = document.getElementById(id);
        e.style.display == 'block' ? e.style.display = 'none' : e.style.display = 'block';
    }
    
    </script>
    <script type="text/javascript">
    <!--
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', ""]);
        _gaq.push(['_trackPageview']);

        (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
    -->
    </script>
    </body>
</html>

