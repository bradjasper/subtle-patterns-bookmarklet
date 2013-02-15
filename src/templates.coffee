template_bookmarklet = """
<div id="subtlepatterns_bookmarklet">
    <div class="wrapper">
        <span class="title">
            <a href="#" target="_blank" class="name"></a>
        </span>
        <div class="controls">
            <a href="javascript:void(0)" class="previous"><img src="https://d2ueh8f0j2xol3.cloudfront.net/subtle-patterns-bookmarklet/static/img/left_arrow.png" /></a>
            <span class="counter">
                <span class="curr"></span>/<span class="total"></span>
            </span>
            <a href="javascript:void(0)" class="next"><img src="https://d2ueh8f0j2xol3.cloudfront.net/subtle-patterns-bookmarklet/static/img/right_arrow.png" /></a>
        </div>
        <div class="categories">
            <select class="category">
            </select>
        </div>
        <div class="about">
            <a href="http://subtlepatterns.com/?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet" target="_blank">SubtlePatterns</a> bookmarklet by
            <a href="http://bradjasper.com/?utm_source=SubtlePatternsBookmarklet&utm_medium=web&utm_campaign=SubtlePatternsBookmarklet" target="_blank">Brad Jasper</a>
       </div>

        <div class="menu_wrapper">
            <ul class="menu">
              <li>
                <a href="javascript:void(0)" class="menu_icon">
                  <img src="https://d2ueh8f0j2xol3.cloudfront.net/subtle-patterns-bookmarklet/static/img/wheel.png" width="11" />
                </a>
                <ul class="submenu dropdown-menu">
                  <li>
                    <a href="javascript:void(0)" class="change_selector">Change Background Selector</a>
                  </li>
                  <li><a href="javascript:void(0)" class="show_keyboard_shortcuts">Show Keyboard Shortcuts</a></li>
                  <li class="divider"></li>
                  <li><a href="javascript:void(0)" class="close_bookmarklet">Close</a></li>
                </ul>
              </li>
            </ul>
            <a href="javascript:void(0)" class="cancel_change_selector">cancel</a>
        </div>

    </div>
    <img class="preload" style="display: none;" />
</div>
"""

template_body = """
<div id="spb_element_selector"></div>
<div id="spb_keyboard_shortcuts">
    <h3>Keyboard Shortcuts</h3>
    <hr>
    <table>
        <tr>
            <th>⟶</th>
            <td>Go to next pattern</td>
        </tr>
        <tr>
            <th>⟵</th>
            <td>Go to previous pattern</td>
        </tr>
        <tr>
            <th>t</th>
            <td>Toggle between active and original pattern</td>
        </tr>
        <tr>
            <th>r</th>
            <td>Change to a random pattern</td>
        </tr>
        <tr>
            <th>s</th>
            <td>Open background selector tool</td>
        </tr>
        <tr>
            <th>?</th>
            <td>Toggle keyboard shortcuts dialog (this dialog)</td>
        </tr>
    </table>
    <a href="javascript:void(0)" class="close_button">
        <img src="https://d2ueh8f0j2xol3.cloudfront.net/subtle-patterns-bookmarklet/static/img/delete_white.png" />
    </a>
</div>
"""
