#!/usr/bin/env python3
# coding: utf-8

import feedparser
import requests
import os
import time
import shlex

FFILE = "/home/kitty/data/torrents/rssfeeds"
with open(FFILE) as f:
    FEEDS = [x.strip() for x in f]

# testing: touch --date='1 week ago' rssfeeds
lastcheck = time.gmtime(os.stat(FFILE).st_mtime)

def link(e):
    if not e['links']:
        return ''
    l = e['links'][0]
    for x in e['links']:
        if x['type'] == 'application/x-bittorrent':
            l = x
    return l['href']

while True:
    for url in FEEDS:
        feed = feedparser.parse(requests.get(url).text)
        print('Processing', len(feed['entries']), 'entries')
        for e in feed['entries']:
            if e['published_parsed'] > lastcheck:
                print("Adding", e['title'])
                os.system('tmux send-keys -t rt:rtorrent BSpace ' +
                    shlex.quote(link(e)) +
                    ' Enter')
                time.sleep(2)
        print('Done.')

    lastcheck = time.gmtime()
    os.utime(FFILE, None)
    time.sleep(2*60*60)
