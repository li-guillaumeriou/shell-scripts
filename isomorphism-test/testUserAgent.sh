#!/bin/bash

# ------------------------------------------------
# Description:
# ------------------------------------------------
# Check that with given user agents, the page is rendered
# when it is retrevied by the search engines
# ------------------------------------------------
# Requirements:
# ------------------------------------------------
# - pup: https://github.com/ericchiang/pup
# - curl
# ------------------------------------------------

# The url to check
TESTING_URL=https://feature-dclw-1011.staging.lux-residence.com/annonces/vente/manoir/france/melun-77000/E066A6FE-8994-D14E-82A7-A016953F1D40
# The expected string that should be missing in the page source
SHOULD_BE_MISSING="\"className\":\"placeholder\""

useragent_list=(
	"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
	"Mozilla/5.0 (compatible; Googlebot-News; +http://www.google.com/bot.html)"
	"Mozilla/5.0 (compatible; Googlebot-Image/1.0; +http://www.google.com/bot.html)"
	"Mozilla/5.0 (compatible; Googlebot-Video/1.0; +http://www.google.com/bot.html)"
	"SAMSUNG-SGH-E250/1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1 UP.Browser/6.2.3.3.c.1.101 (GUI) MMP/2.0 (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)"
	"Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
	"Mozilla/5.0 (compatible; Mediapartners-Google/2.1; +http://www.google.com/bot.html)"
	"Mozilla/5.0 (compatible; Mediapartners-Google; +http://www.google.com/bot.html)"
	"AdsBot-Google (+http://www.google.com/adsbot.html)"
	"Mozilla/5.0 (compatible; AdsBot-Google-Mobile-Apps; +http://www.google.com/bot.html)"
	"Mozilla/5.0 (compatible; Bingbot/2.0; +http://www.bing.com/bingbot.htm)"
	"Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)"
	"DuckDuckBot/1.0; (+http://duckduckgo.com/duckduckbot.html)"
	"Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)"
	"Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
	"Sogou Pic Spider/3.0( http://www.sogou.com/docs/help/webmasters.htm#07)"
	"Sogou head spider/3.0( http://www.sogou.com/docs/help/webmasters.htm#07)"
	"Sogou web spider/4.0(+http://www.sogou.com/docs/help/webmasters.htm#07)"
	"Sogou Orion spider/3.0( http://www.sogou.com/docs/help/webmasters.htm#07)"
	"Sogou-Test-Spider/4.0 (compatible; MSIE 5.5; Windows 98)"
	"Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.5 (like Gecko) (Exabot-Thumbnails)"
	"Mozilla/5.0 (compatible; Exabot/3.0; +http://www.exabot.com/go/robot)"
	"facebot"
	"facebookexternalhit/1.0 (+http://www.facebook.com/externalhit_uatext.php)"
	"facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)"
	"ia_archiver"
	"Yeti/1.0 (NHN Corp.; http://help.naver.com/robots/)"
	"Mozilla/5.0 (compatible; YodaoBot/1.0; http://www.yodao.com/help/webmaster/spider/; )"
	"Gigabot/3.0 (http://www.gigablast.com/spider.html)"
	"Twitterbot/1.0"
	"APIs-Google (+https://developers.google.com/webmasters/APIs-Google.html)"
)



# Curl cli arguments
CURL_ARGS="-k -s -H 'Cache-Control: no-cache'"

# Formating script output
PASS_ICO="\xE2\x9C\x94"
FAIL_ICO="\xE2\x9D\x8C"
GREEN_COL="\e[32m"
RED_COL="\e[31m"
YEL_COL="\e[33m"
BOLD="\e[1m"
NORMAL="\e[0m"

# Counters
OK=0 # test passed
KO=0 # test failed
TOTAL=0 # total test count

# Looping over user agents list
for USER_AGENT in "${useragent_list[@]}"
do
	TOTAL=$((TOTAL+1))
	# Logging current user agent string
	printf "${NORMAL}${BOLD} Testing with user agent: ${NORMAL}${YEL_COL} ${USER_AGENT}\n"

	# Executing curl command
	stdout=$(curl ${TESTING_URL} --user-agent "${USER_AGENT}" ${CURL_ARGS} | pup 'script' --color)
	# Checking page source
	rendered=$(echo ${stdout} | grep -o "${SHOULD_BE_MISSING}")

	# Logging test result
	if [ "${SHOULD_BE_MISSING}" == "${rendered}" ]; then
		printf "${RED_COL}${FAIL_ICO}  rendering failed\n"
		KO=$((KO+1))
	else
		printf "${GREEN_COL}${PASS_ICO}  rendering ok\n"
		OK=$((OK+1))
	fi
	printf "\n"
done	

# Logging test report summary
printf "\n ${NORMAL}${BOLD}Total: ${TOTAL}. ${NORMAL}${RED_COL}(${KO}) Failed. ${GREEN_COL}(${OK}) Passed.\n\n\n"

# Script exit code
if [ ${KO} -eq 0 ] ; then
	exit 0;
else
	exit 1;
fi