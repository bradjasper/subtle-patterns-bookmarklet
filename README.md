SubtlePatterns Bookmarklet is a quick and easy way to see patterns from http://subtlepatterns.com on your site.

```javascript
javascript:(function()%7Bvar%20newscript%3Ddocument.createElement(%27script%27)%3Bnewscript.type%3D%27text/javascript%27%3Bnewscript.async%3Dtrue%3Bnewscript.src%3D%27http://bradjasper.com/subtle-patterns-bookmarklet/bookmarklet.js%3Fcb%3D%27%20%2B%20Math.random()%3B(document.getElementsByTagName(%27head%27)%5B0%5D%7C%7Cdocument.getElementsByTagName(%27body%27)%5B0%5D).appendChild(newscript)%3B%7D)()%3B
```

## Install
<a href="http://bradjasper.com/subtle-patterns-bookmarklet/">Head over to this page</a> where you can drag and drop the bookmarklet on to your bookmarks bar.

## Usage
Press left and right to move between patterns. The current pattern is displayed in the lower left corner of the browser.
