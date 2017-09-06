{extends "designs/site.tpl"}

{block meta}
    <link rel="alternate" type="application/rss+xml" title="RSS" href="/sections/{$data->Handle}/rss">
{/block}

{block title}{$data->Title|escape} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    <script type="text/javascript">
        var SiteEnvironment = SiteEnvironment || { };
        SiteEnvironment.courseSection = {JSON::translateObjects($data, false, 'recordURL')|json_encode};
    </script>

    {$dwoo.parent}

    {if !$.get.jsdebug}
        <script src="{Site::getVersionedRootUrl('js/pages/CourseSection.js')}"></script>
    {/if}

    <script>
        Ext.require('Site.page.CourseSection');
    </script>
{/block}


{block "content"}
    {load_templates "subtemplates/blog.tpl"}
    {load_templates "subtemplates/paging.tpl"}

    {$Section = $data}

    <?php
        $this->scope['limit'] = 10;
        $options = [
            'limit' => $this->scope['limit'],
            'offset' => $_GET['offset'] ?: 0,
            'calcFoundRows' => 'yes',
            'conditions' => []
        ];

        $sectionTeacherIds = array_map(function($Teacher) {
            return $Teacher->ID;
        }, $this->scope['Section']->Teachers);

        $latestTeacherPost = \Emergence\CMS\BlogPost::getAllPublishedByContextObject($this->scope['Section'], array_merge_recursive($options, [
            'conditions' => [
                'AuthorID' => [
                    'operator' => 'IN',
                    'values' => $sectionTeacherIds
                ]
            ],
            'limit' => 1
        ]));

        if (count($latestTeacherPost)) {
            $this->scope['latestTeacherPost'] = $latestTeacherPost[0];
            $options['conditions'][] = sprintf('ID != %u', $this->scope['latestTeacherPost']->ID);
        }

        $this->scope['blogPosts'] = \Emergence\CMS\BlogPost::getAllPublishedByContextObject($this->scope['Section'], $options);
        $this->scope['total'] = DB::foundRows();
    ?>

    <div class="sidebar-layout">
        <div class="main-col">
            <div class="col-inner">
                <header class="page-header">
                    <h2 class="header-title">{$Section->Title|escape}</h2>
                </header>

                {if $latestTeacherPost}
                    <div class="well">
                        <header class="page-header">
                            <h3 class="header-title">Teacher's Latest Post</h3>
                        </header>
                        {blogPost $latestTeacherPost headingLevel="h4"}
                    </div>
                {/if}

                <header class="page-header">
                    <h3 class="header-title">Class Blog</h3>
                    <div class="header-buttons"><a href="{$Section->getURL()}/post" class="button primary">Create a Post</a></div>
                </header>

                {foreach item=BlogPost from=$blogPosts}
                    {blogPost $BlogPost headingLevel="h4"}
                {foreachelse}
                    <p class="empty-text">This class has no posts in its public feed yet.</p>
                {/foreach}

                <footer class="page-footer">
                    {if $total > $limit}
                        <div class="pagingLinks">
                            <strong>{$total|number_format} post{tif $total != 1 ? s}:</strong> {pagingLinks $total pageSize=$limit}
                        </div>
                    {/if}

                    <a href="/sections/{$Section->Handle}/rss"><img src="{versioned_url img/rss.png}" width=14 height=14 alt="RSS"></a>
                </footer>
            </div>
        </div>

        <div class="sidebar-col">
            <div class="col-inner">

                <section class="well course-section-details">
                    <h3 class="well-title">{$Section->Code|escape}</h3>

                    {if $Section->Course->Description}
                        <div class="muted markdown-ct">{$Section->Course->Description|escape|markdown}</div>
                    {/if}

                    <dl class="kv-list align-right">
                        <div class="dli">
                            <dt>Term</dt>
                            <dd>{$Section->Term->Title}</dd>
                        </div>

                        {if $.User}
                            <div class="dli">
                                <dt>Schedule</dt>
                                <dd>{$Section->Schedule->Title}</dd>
                            </div>
                            <div class="dli">
                                <dt>Location</dt>
                                <dd>{$Section->Location->Title}</dd>
                            </div>
                        {/if}

                        {if $Section->Notes}
                            <div class="dli">
                                <dt>Notes</dt>
                                <dd class="markdown-ct">{$Section->Notes|escape|markdown}</dd>
                            </div>
                        {/if}
                    </dl>
                </section>

            {*
                {$MoodleMapping = SynchronizationMapping::getByWhere(array(
                    ContextClass = 'CourseSection'
                    ,ContextID = $Section->ID
                    ,ExternalSource = 'MoodleIntegrator'
                    ,ExternalKey = 'id'
                ))}

                {if $MoodleMapping}
                    <h2>Links</h2>
                    <ul>
                        <li><a href="/cas/login?service={urlencode('http://moodle.scienceleadership.org/course/view.php?id=')}{$MoodleMapping->ExternalIdentifier}" title="Visit {$Section->Code} on Moodle">Moodle / {$Section->Code|escape}</a></li>
                    </ul>
                {/if}
            *}

                <?php
                    if (class_exists("Slate\\Connectors\\Canvas\\Connector") && class_exists("RemoteSystems\\Canvas", false)) {
                        $this->scope['canvasConnectorId'] = \Slate\Connectors\Canvas\Connector::$connectorId;
                    }
                ?>
                {if $canvasConnectorId}
                    <h3 class="well-title">Other Websites</h3>
                    {foreach from=$Section->Mappings item=SectionMapping}
                        {if $SectionMapping->ExternalKey == "course_section[id]" && $SectionMapping->Connector == $canvasConnectorId}
                            <a href="http://{\RemoteSystems\Canvas::$canvasHost}/courses/{$SectionMapping->ExternalIdentifier}" target="_blank">Launch Canvas</a>
                        {/if}
                    {/foreach}
                {/if}

                {if $.User->hasAccountLevel(Staff)}
                    <h3 class="well-title">Course Tools</h3>
                    <ul class="course-section-tools plain">
                        <li class="copy-email"><a class="button" href="#copy-section-emails">Copy Email List</a></li>
                        <li class="download-roster"><a class="button" href="{$Section->getURL()}/students?format=csv&columns=LastName,FirstName,Gender,Username,PrimaryEmail,PrimaryPhone,StudentNumber,Advisor,GraduationYear">Download Roster</a></li>
                    </ul>
                {/if}

                    <h3>Teacher{tif count($Section->Teachers) != 1 ? s}</h3>
                    <ul class="roster teachers">
                    {foreach item=Teacher from=$Section->Teachers}
                        <li>{personLink $Teacher photo=true}</li>
                    {foreachelse}
                        <p class="empty-text">No instructors currently listed.</p>
                    {/foreach}
                    </ul>

                {if $.User}
                    <h3>Students</h3>
                    <ul class="roster students">
                    {foreach item=Student from=$Section->Students}
                        <li>{personLink $Student photo=true}</li>
                    {foreachelse}
                        <p class="empty-text">No students currently listed.</p>
                    {/foreach}
                    </ul>
                {/if}

            </div>
        </div>
    </div>
{/block}