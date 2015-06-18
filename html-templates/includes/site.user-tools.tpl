<div class="slate-omnibar site">
    {if $.User}
    {include "/site-root/img/slate-icons/slate-icons.svg"}
    {/if}

    <div class="inner">
        <ul class="omnibar-items">
            {if $.User}
            <li class="omnibar-item">
                <a class="omnibar-link root-link" href="/">
                    <svg class="slate-logo" viewBox="0 0 500 392.4"><g fill="currentcolor"><path d="M493.5 190.5h-33.9v92.1H500v22.9h-66.2V60.1h66v22.5h-40.2v84.2h33.9M126.4 60.1v222.5h37.1v23.2H99.1V60.1m-52.5 67V95.8s0-10.7-8.8-10.6c-8 .1-7.1 11.3-7.1 11.3V122s-.3 5.5 2.1 12.1l39.1 69.8c5.7 10 4.9 16.6 5 23.4.1 3.4 0 22.8 0 49.7 0 16.2-13.6 28.5-36.6 29.5-.9 0-1.8.1-2.8.1-26 .1-37.6-14.5-37.5-31.7v-39.5h26.6s-.2 33.1 0 35.5-.2 11.7 11.5 11.8c10.9.1 12.5-8.7 12.6-11.8v-40c-.1-4.1-1.5-11.2-5.1-17.4-1.3-2.3-29.8-50.1-32.5-55.5-6.6-12.9-10.8-19.4-10.7-32.3.2-12.9 0-36.3 0-40.6 0-11.2 10.8-25.3 35.1-25.5C60.9 59.5 72 76.5 72 85.2l-.2 41.9"/><circle cx="197.4" cy="353.4" r="14.5"/><path d="M188.5 383.2l4.5 9.2v-9.1z"/><circle cx="303.8" cy="353.6" r="14.5"/><path d="M323.8 310.6m29.6-5.1v-223h-29.3V60.1h86.2v22.4h-28.9v223"/><circle cx="251" cy="80.8" r="14.5"/><path d="M328.4 215.7h-30.1L267 45h-5.7l-2.2-4.2-4-4.8 3.2-33.7s-1.8-2.4-6.8-2.4-6.9 2.4-6.9 2.4l3.2 33.6-4.3 4.8-1.8 4.2h-6.1L204 215.7h-32.4s-2.6 1.7-2.6 7 2.6 7 2.6 7h29.8l-22.6 122.1 6.2 19.7 2.9 10.5 5 10.2.5-10.1s1.2-5.5 3.1-14.5c-7.4-.5-13.3-6.7-13.3-14.2 0-7.9 6.4-14.2 14.2-14.2 1.7 0 3.4.3 4.9.9l20.9-110.4h56.6l20.1 110.2c.2 0 .3-.1.5-.1 1.1-.3 2.2-.4 3.4-.4 7.9 0 14.2 6.4 14.2 14.2 0 7.2-5.4 13.2-12.4 14.1 1.8 8.7 2.9 14.1 2.9 14.1l.8 4.5.1 5.7 3.1-5.9 2.2-4.3 2.1-10.3 5-20-5.9-38.1 2.6-.5 1 6.7c.2 1.3 1.4 2.2 2.8 2 1.3-.2 2.2-1.4 2-2.8l-1-6.7c0 .2.1.4.1.4 1.2-.2 2.1-1.3 2-2.5v-.4c-.3-1.2-1.4-2.1-2.7-1.9l-1-6.3c-.2-1.3-1.4-2.2-2.8-2-1.3.2-2.2 1.4-2 2.8l1 6.8-2.7.5-14.7-79.9H328s2.6-1.7 2.6-7-2.2-6.9-2.2-6.9zm-102.6 0l22.9-120.8c-6.7-1.1-11.9-7-11.9-14 0-7.9 6.4-14.2 14.2-14.2 7.9 0 14.2 6.4 14.2 14.2 0 6.5-4.3 11.9-10.3 13.7L277 215.8h-51.2z"/></g></svg>
                </a>
            </li>
            {/if}

            <li class="omnibar-item omnibar-search-item">
                <form class="omnibar-search-form" action="/search">
                    <input class="omnibar-search-field" name="q" type="search" placeholder="Search" required>
                </form>
            </li>

            {template omnibarChildLink link parentLink=null labelPrefix=null}
                {if $parentLink && !$link.icon && !$link.iconSrc}
                    {if $parentLink.icon}
                        {$link.icon = $parentLink.icon}
                    {/if}
                    {if $parentLink.iconSrc}
                        {$link.iconSrc = $parentLink.iconSrc}
                    {/if}
                {/if}

                {if $link.href}
                    <li class="omnibar-menu-item" {html_attributes_encode $link prefix='data-' deep=no}>
                        <a class="omnibar-menu-link" href="{$link.href|escape}" title="{$link.label|escape}">
                            <figure class="omnibar-menu-icon">
                                <div class="omnibar-menu-image-ct">
                                    <svg class="omnibar-menu-image-bg"><use xlink:href="#icon-squircle"/></svg>
                                    <svg class="omnibar-menu-image"><use xlink:href="#icon-{$link.icon|default:'link'|escape}"/></svg>
                                </div>
                                <figcaption class="omnibar-menu-label">
                                    {if $labelPrefix}
                                        <small class="muted">{$labelPrefix|escape}</small><br>
                                    {/if}
                                    {$link.shortLabel|default:$link.label|escape}
                                </figcaption>
                            </figure>
                        </a>
                    </li>
                {/if}

                {if $link.children}
                    {foreach item=childLink from=$link.children}
                        {$parentLabel = $link.shortLabel|default:$link.label}
                        {omnibarChildLink $childLink parentLink=$link labelPrefix=tif($labelPrefix, cat($labelPrefix, ' » ', $parentLabel), $parentLabel)}
                    {/foreach}
                {/if}
            {/template}

            {template omnibarLink link}
                <li class="omnibar-item" {html_attributes_encode $link prefix='data-' deep=no}>
                    <{if $link.href}a href="{$link.href|escape}"{else}span{/if} class="omnibar-link" title="{$link.label|escape}">
                        {if $link.iconSrc}
                            <img class="omnibar-link-image" src="{$link.iconSrc|escape}" alt="{$link.label|escape}" width="24" height="24">
                        {/if}
                        {$link.shortLabel|default:$link.label|escape}
                    </{tif $link.href ? a : span}>
                    
                    {if $link.children}
                        <div class="omnibar-menu-ct">
                            <ul class="omnibar-menu">
                                {foreach item=childLink from=$link.children}
                                    {omnibarChildLink $childLink parentLink=$link}
                                {/foreach}
                            </ul>
                        </div>
                    {/if}
                </li>
            {/template}


            {foreach item=link from=Slate\UI\Omnibar::getLinks()}
                {omnibarLink $link}
            {/foreach}
        </ul>
    </div>
</div>