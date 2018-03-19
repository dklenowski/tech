Categories: web
Tags: css
	  web


# CSS Notes


## Remove blue glow from button

		.btn,
		.btn:hover,
		.btn:active,
		.btn:focus {
			    outline: 0;		
		}



## Aignment

- For `relative` and `absolute` use `display: inline-block` to fill remaining space with other items.
  - i.e. using `display: block` fills horizontal space with a margin.


## Using a fixed div

		<style>
		.video-fixed {
		    left: 50%;
		    top: 65px;
		    padding-top: 20px;
		    width: 60%;
		    transform: translateX(-50%);
		    background-color: #FFFFFF;
		}
		
		.video-relative {
		    margin-top: 600px;
		
		}
		</style>
		<div class="video-fixed" data-spy="affix">
		</div>
		<div class="video-relative">
		</div>
 
 # Bootstrap Notes


 ## nav tab without shadows/buttons


		.nav-tabs {
		    display: inline-block;
		    text-align: center;
		}
		
		.nav-tabs,
		.nav-tabs > li > a,
		.nav-tabs > li > a:hover,
		.nav-tabs > li > a:focus,
		.nav-tabs > li.active > a,
		.nav-tabs > li.active > a:hover,
		.nav-tabs > li.active > a:focus {
		    border: none;
		    background: transparent;
		}
		
		.nav-tabs > li > a {
		    text-decoration: none;
		    font-size: 18px;
		    color: #000000;
		    padding: 0;
		    margin: 10px;
		}
		
		.nav-tabs > li.active > a,
		.nav-tabs > li.active > a:hover,
		.nav-tabs > li.active > a:focus {
		    color: #999999;
		}
