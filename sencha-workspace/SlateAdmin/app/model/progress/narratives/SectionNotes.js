/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext,Slate*/
Ext.define('SlateAdmin.model.progress.narratives.SectionNotes', {
    extend: 'Ext.data.Model',
    requires: [
        'SlateAdmin.proxy.Records',
        'Ext.data.identifier.Negative'
    ],


    // model config
    idProperty: 'ID',
    identifier: 'negative',

    fields: [
        {
            name: 'ID',
            type: 'int',
            allowNull: true
        },
        {
            name: 'Class',
            type: 'string',
            defaultValue: 'Slate\\Progress\\Narratives\\SectionNotes'
        },
        {
            name: 'Created',
            type: 'date',
            dateFormat: 'timestamp',
            allowNull: true
        },
        {
            name: 'CreatorID',
            type: 'int',
            allowNull: true
        },
        {
            name: 'CourseSectionID',
            type: 'int'
        },
        {
            name: 'TermID',
            type: 'int'
        },
        {
            name: 'Notes',
            type: 'string',
            allowNull: true
        },
        {
            name: 'Modified',
            type: 'date',
            dateFormat: 'timestamp',
            allowNull: true
        },
        {
            name: 'ModifierID',
            type: 'int',
            allowNull: true
        }
    ],

    proxy: {
        type: 'slaterecords',
        url: '/progress/narratives/section-notes'
    }
});