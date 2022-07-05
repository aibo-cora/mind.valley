#  Mind Valley

Another great addition to my portfolio. This project is designed with extensive use of <code>Generics, Combine, SwiftUI</code>.
<br>
<br>
Architecture: <code> MVVM </code>
<br>
Platforms: <code> iPad, iPhone </code>
<br>
<br>
<h2> Generics </h2>
<ul>
    <li> Network response decoding </li>
    <li> View composition </li>
</ul>

<h2> Combine </h2>
There are 3 <code>dataTaskPublisher</code>s that are being combined to notify the app that the data has been downloaded and it's time to render the UI.

<br>
<h2> SwiftUI </h2>
There are 5 tiny views that are the foundation of a complex UI design.

<br>
<h2> Image Caching </h2>
Using <code>Nuke</code> https://github.com/kean/Nuke

<br>
<h2> JSON caching </h2>
It would be better to have a <code>version</code> field in each JSON, so that when the JSON changes, the version is updated and a new copy can be stored locally. (CMS)

<br>
<h2> Known Issues - UI </h2>
<ul>
    <li> Icon thumbnail URL requests return <code>404</code> server error. </li>
    <li> Maybe cache more images instead of lazily downloading them? </li>
</ul>

<br>
<h2> Improvements - Architecture </h2>
<ul>
    <li> Use a dedicated class for file operations. </li>
</ul>
