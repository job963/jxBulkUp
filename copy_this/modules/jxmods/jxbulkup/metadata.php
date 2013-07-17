<?php

/**
 * Metadata version
 */
$sMetadataVersion = '1.1';
 
/**
 * Module information
 */
$aModule = array(
    'id'           => 'jxbulkup',
    'title'        => 'jxBulkUp - Bulk Update Tool for Products',
    'description'  => array(
                        'de'=>'Massen-Aktualisierung von Artikeln',
                        'en'=>'Bulk Update of Products'
                        ),
    'thumbnail'    => 'jxbulkup.png',
    'version'      => '0.1',
    'author'       => 'Joachim Barthel',
    'url'          => 'https://github.com/job963/jxBulkUp',
    'email'        => 'jobarthel@gmail.com',
    'extend'       => array(
                        ),
    'files'        => array(
        'jxbulkup'     => 'jxmods/jxbulkup/application/controllers/admin/jxbulkup.php'
                        ),
    'templates'    => array(
        'jxbulkup.tpl' => 'jxmods/jxbulkup/views/admin/tpl/jxbulkup.tpl'
                        ),
/*    'events'       => array(
        'onActivate'   => 'install_jxinventory::onActivate', 
        'onDeactivate' => 'install_jxinventory::onDeactivate'
                        ),
    'settings'     => array(
                        array(
                            'group' => 'JXINVENTORY_DEACTIVATESETTINGS', 
                            'name'  => 'bJxInventoryDropOnDeactivate', 
                            'type'  => 'bool', 
                            'value' => 'false'
                            )
                        )*/
    );

?>
