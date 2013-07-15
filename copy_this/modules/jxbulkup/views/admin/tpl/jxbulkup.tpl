[{*debug*}]
[{include file="headitem.tpl" title="GENERAL_ADMIN_TITLE"|oxmultilangassign box=" "}]

<script type="text/javascript">
  if(top)
  {
    top.sMenuItem    = "[{ oxmultilang ident="mxmanageprod" }]";
    top.sMenuSubItem = "[{ oxmultilang ident="jxbulkup_menu" }]";
    top.sWorkArea    = "[{$_act}]";
    top.setTitle();
  }

    function disableForm (sFormName) 
    {
        var limit = document.getElementById(sFormName).elements.length;
        for (i=0;i<limit;i++) {
          document.getElementById(sFormName).elements[i].disabled = true;
        }
    }
</script>

<style>
    input[type="text"]:disabled {
        background-color: #e5e5e5;
        border: 1px solid #bcbcbc;
        }
        
    select:disabled {
        background-color: #e5e5e5;
        border: 1px solid #bcbcbc;
        }
</style>

<body onresize="resizeCodeFrame();">
<div class="center" style="height:100%;">
    <h1>[{ oxmultilang ident="JXBULKUP_TITLE" }]</h1>
    <form name="transfer" id="transfer" action="[{ $shop->selflink }]" method="post">
        [{ $shop->hiddensid }]
        <input type="hidden" name="oxid" value="[{ $oxid }]">
        <input type="hidden" name="cl" value="article" size="40">
        <input type="hidden" name="updatelist" value="1">
    </form>

    <table width="99%">
        <tr>
            <td width="32%" valign="top" style="border:[{if $sStep==""}]1px solid #666;[{else}]1px solid #bbb;background-color:#f7f7f7;[{/if}]padding:4px; height:100%">
                <form name="jxbulkup_search" id="jxbulkup_search" action="[{ $shop->selflink }]" method="post">
                    <input type="hidden" name="editlanguage" value="[{ $editlanguage }]">
                    <input type="hidden" name="cl" value="jxbulkup">
                    <input type="hidden" name="fnc" value="">
                    <input type="hidden" name="oxid" value="[{ $oxid }]">
                    <input type="hidden" name="step" value="searchProducts">

                    <div style="font-size:1.25em;font-weight:bold;padding-bottom:8px;color:[{if $sStep==""}]#000;[{else}]#888;[{/if}]">[{ oxmultilang ident="JXBULKUP_BLOCKSEARCH" }]</div>
                    <table width="100%" border="0">
                        <tr>
                            <td valign="top">[{ oxmultilang ident="JXBULKUP_SEARCHTEXT" }]:</td>
                            <td>
                                <input type="text" name="jx_srcval" value="[{ $jx_srcval }]" style="position:relative; top:-4px;">
                                [{*<input type="text" name="jxbulkup_srcval" value="[{ $jxbulkup_srcval }]">*}] 
                                [{ oxinputhelp ident="HELP_GENERAL_NAME" }]
                                <input type="button" id="helpBtn_jxSrcVal" class="btnShowHelpPanel" onClick="YAHOO.oxid.help.showPanel('jxSrcVal');" style="position:relative; top:4px;">
                                <div id="helpText_jxSrcVal" class="helpPanelText">
                                [{ oxmultilang ident="JXBULKUP_SEARCHTEXTINFO" }]
                                </div>
                            </td>
                            <td valign="top">
                                <input type="submit" value=" [{ oxmultilang ident="JXBULKUP_SEARCHBTN" }] " 
                                       onclick="document.forms.jxbulkup_search.submit;">
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" colspan="2" height="8px"></td>
                        </tr>
                        <tr>
                            <td valign="top">[{ oxmultilang ident="JXBULKUP_OPTIONS" }]</td>
                            <td valign="top">
                                <input type="checkbox" name="jx_active" id="jx_active" value="jx_active" [{if $jx_active=="jx_active"}]checked="checked"[{/if}]> 
                                <label for="jx_active">[{ oxmultilang ident="JXBULKUP_ACTPRODONLY" }]</label><br>
                                <input type="checkbox" name="jx_incvars"" id="jx_incvars" value="jx_incvars" [{if $jx_incvars=="jx_incvars"}]checked="checked"[{/if}]> 
                                <label for="jx_incvars">[{ oxmultilang ident="JXBULKUP_INCLVARS" }]</label><br>
                            </td>
                        </tr>
                    </table>
                    <div id="jx_srcmsg" style="position:relative;bottom:-70px;padding-left:4px;font-style:italic;font-weight:bold;"></div>
                </form>
            </td>

            <td></td>

            <td width="32%" valign="top" style="border:[{if $sStep=="searchProducts"}]1px solid #666;[{else}]1px solid #bbb;background-color:#f7f7f7;[{/if}]padding:4px; height:100%">
                <form name="jxbulkup_display" id="jxbulkup_display" action="[{ $shop->selflink }]" method="post">
                    <input type="hidden" name="editlanguage" value="[{ $editlanguage }]">
                    <input type="hidden" name="cl" value="jxbulkup">
                    <input type="hidden" name="fnc" value="">
                    <input type="hidden" name="oxid" value="[{ $oxid }]">
                    <input type="hidden" name="step" value="displayUpdateField">
                    <input type="hidden" name="jx_srcval" value="[{ $jx_srcval }]">
                    <input type="hidden" name="jx_active" value="[{ $jx_active }]">
                    <input type="hidden" name="jx_incvars" value="[{ $jx_incvars }]">

                    <div style="font-size:1.25em;font-weight:bold;padding-bottom:8px;color:[{if $sStep=="searchProducts"}]#000;[{else}]#888;[{/if}]">[{ oxmultilang ident="JXBULKUP_BLOCKDISPLAY" }]</div>
                    <table width="100%" border="0">
                        <tr>
                        <td valign="top">[{ oxmultilang ident="JXBULKUP_FIELD" }]:</td>
                        <td>
                            <input type="radio" id="oxartnum" name="jx_updfield" value="oxartnum" [{if $jx_updfield=="oxartnum"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxartnum">[{ oxmultilang ident="GENERAL_ITEMNR" }]</label><br />
                            <input type="radio" id="oxtitle" name="jx_updfield" value="oxtitle" [{if $jx_updfield=="oxtitle"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxtitle">[{ oxmultilang ident="GENERAL_TITLE" }]</label><br />
                            [{if $jx_incvars=="jx_incvars"}]
                                <input type="radio" id="oxvar" name="jx_updfield" value="oxvar" [{if $jx_updfield=="oxvar"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                                <label for="oxvar">[{ oxmultilang ident="JXBULKUP_VARIANT" }]</label><br />
                            [{/if}]
                            <input type="radio" id="oxshortdesc" name="jx_updfield" value="oxshortdesc" [{if $jx_updfield=="oxshortdesc"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxshortdesc">[{ oxmultilang ident="GENERAL_SHORTDESC" }]</label><br />
                            <input type="radio" id="oxlongdesc" name="jx_updfield" value="oxlongdesc" [{if $jx_updfield=="oxlongdesc"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxlongdesc">[{ oxmultilang ident="ARTICLE_EXTEND_DESCRIPTION" }]</label><br />
                            <input type="radio" id="oxsearchkeys" name="jx_updfield" value="oxsearchkeys" [{if $jx_updfield=="oxsearchkeys"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxsearchkeys">[{ oxmultilang ident="ARTICLE_MAIN_SEARCHKEYS" }]</label><br />
                            <input type="radio" id="oxtags" name="jx_updfield" value="oxtags" [{if $jx_updfield=="oxtags"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxtags">[{ oxmultilang ident="ARTICLE_MAIN_TAGS" }]</label><br />
                            <input type="radio" id="oxdeltime" name="jx_updfield" value="oxdeltime" [{if $jx_updfield=="oxdeltime"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxdeltime">[{ oxmultilang ident="JXBULKUP_DELTIMES" }]</label><br />
                            <input type="radio" id="oxremind" name="jx_updfield" value="oxremind" [{if $jx_updfield=="oxremind"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxremind">[{ oxmultilang ident="JXBULKUP_STOCKREMINDER" }]</label><br />
                            <nobr><input type="radio" id="jxattributes" name="jx_updfield" value="jxattributes" [{if $jx_updfield=="jxattributes"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=false;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="jxattributes">[{ oxmultilang ident="JXBULKUP_ATTRIBUTE" }]</label>
                            <select name="jx_attribute" id="jx_attribute" size="1" [{if $jx_updfield!="jxattributes"}]disabled="disabled"[{/if}]>
                                [{foreach name=outer item=Attribute from=$aAttributes}]
                                    <option value="[{ $Attribute.oxid }]" [{if $jx_attribute==$Attribute.oxid}]selected[{/if}]>[{ $Attribute.oxtitle }]</option>
                                [{/foreach}]
                            </select></nobr><br />
                            <input type="radio" id="oxprice" name="jx_updfield" value="oxprice" [{if $jx_updfield=="oxprice"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_display.jx_attribute.disabled=true;document.forms.jxbulkup_display.btndisplay.disabled=false;"> 
                            <label for="oxprice">[{ oxmultilang ident="GENERAL_PRICE" }]</label><br />
                        </td>
                            <td valign="top">
                                <input type="submit" id="btndisplay" value=" [{ oxmultilang ident="JXBULKUP_DISPLAYBTN" }] " [{if $jx_updfield==""}]disabled="disabled"[{/if}]
                                       onclick="document.forms.jxbulkup_display.submit;">
                            </td>
                    </tr></table>
                </form>
            </td>

            <td></td>

            <td width="33%" valign="top" style="border:[{if $sStep=="displayUpdateField"||$sStep=="testUpdate"}]1px solid #666;[{else}]1px solid #bbb;background-color:#f7f7f7;[{/if}]padding:4px; height:100%">
                <form name="jxbulkup_update" id="jxbulkup_update" action="[{ $shop->selflink }]" method="post">
                    <input type="hidden" name="editlanguage" value="[{ $editlanguage }]">
                    <input type="hidden" name="cl" value="jxbulkup">
                    <input type="hidden" name="fnc" value="">
                    <input type="hidden" name="oxid" value="[{ $oxid }]">
                    <input type="hidden" name="step" value="">
                    <input type="hidden" name="jx_srcval" value="[{ $jx_srcval }]">
                    <input type="hidden" name="jx_active" value="[{ $jx_active }]">
                    <input type="hidden" name="jx_incvars" value="[{ $jx_incvars }]">
                    <input type="hidden" name="jx_updfield" value="[{ $jx_updfield }]">
                    <input type="hidden" name="jx_attribute" value="[{ $jx_attribute }]">

                    <div style="font-size:1.25em;font-weight:bold;padding-bottom:8px;color:[{if $sStep=="displayUpdateField"||$sStep=="testUpdate"}]#000;[{else}]#888;[{/if}]">[{ oxmultilang ident="JXBULKUP_BLOCKUPDATE" }]</div>
                    <table width="100%" border="0" style="padding-right:10px;">
                        <tr>
                            [{if $jx_updfield == "oxdeltime"}]
                                <td valign="top"><nobr>[{ oxmultilang ident="JXBULKUP_NEWVALUES" }]:</nobr></td>
                                <td valign="top">
                                    <input type="text" name="jx_updval_min" size="2" value="[{ $jx_updval_min }]"> bis 
                                    <input type="text" name="jx_updval_max" size="2" value="[{ $jx_updval_max }]">
                                    <select name="jx_updval_unit" id="jx_updval_unit" size="1">
                                        <option value="DAY" [{if $jx_updval_unit == "DAY"}]selected[{/if}]>Tage</option>
                                        <option value="WEEK" [{if $jx_updval_unit == "WEEK"}]selected[{/if}]>Wochen</option>
                                        <option value="MONTH" [{if $jx_updval_unit == "MONTH"}]selected[{/if}]>Monate</option>
                                    </select>
                                </td>
                            [{elseif $jx_updfield == "oxremind"}]
                                <td valign="top"><nobr>[{ oxmultilang ident="JXBULKUP_NEWVALUES" }]:</nobr></td>
                                <td valign="top">
                                    <input type="checkbox" name="jx_updval_remind" id="jx_updval_remind" value="jx_updval_remind" [{if $jx_updval_remind=="jx_updval_remind"}]checked="checked"[{/if}]
                                           onchange="if (this.checked) document.forms.jxbulkup_update.jx_updval_min.disabled=false; else document.forms.jxbulkup_update.jx_updval_min.disabled=true;"> 
                                    <label for="jx_updaval_remind">[{ oxmultilang ident="JXBULKUP_REMINDER" }]</label><br>
                                    [{ oxmultilang ident="JXBULKUP_MIN" }] <input type="text" id="jx_updval_min" name="jx_updval_min" size="2" value="[{ $jx_updval_min }]" [{if $jx_updval_remind!="jx_updval_remind"}]disabled="disabled"[{/if}]> [{ oxmultilang ident="GENERAL_ITEM" }]
                                </td>
                            [{else}]
                                <td valign="top"><nobr>[{ oxmultilang ident="JXBULKUP_NEWVALUE" }]:</nobr></td>
                                <td valign="top"><input type="text" name="jx_updval" size="20" value="[{ $jx_updval }]"></td>
                            [{/if}]
                            <td valign="top">
                                <input type="submit" id="btntest" value=" [{ oxmultilang ident="JXBULKUP_TESTBTN" }] " [{if $jx_updmode==""}]disabled[{/if}] style="width:100%;"
                                       onclick="document.forms.jxbulkup_update.step.value='testUpdate';document.forms.jxbulkup_update.submit;"><br />
                                <input type="submit" id="btnupdate" value=" [{ oxmultilang ident="JXBULKUP_UPDATEBTN" }] " [{if $sStep!="testUpdate"}]disabled[{/if}] style="width:100%;"
                                       onclick="document.forms.jxbulkup_update.step.value='executeUpdate';document.forms.jxbulkup_update.submit;">
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">[{ oxmultilang ident="JXBULKUP_MODE" }]:</td>
                            [{if $jx_updfield == "oxdeltime"}]
                                <td>
                                    <input type="radio" id="overwrite" name="jx_updmode" value="OVERWRITE" [{if $jx_updmode=="OVERWRITE"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_update.btntest.disabled=false"> 
                                    <label for="overwrite">[{ oxmultilang ident="JXBULKUP_OVERWRITE" }]</label><br />
                                </td>
                            [{elseif $jx_updfield == "oxremind"}]
                                <td>
                                    <input type="radio" id="overwrite" name="jx_updmode" value="OVERWRITE" [{if $jx_updmode=="OVERWRITE"}]checked="checked"[{/if}] onchange="document.forms.jxbulkup_update.btntest.disabled=false"> 
                                    <label for="overwrite">[{ oxmultilang ident="JXBULKUP_OVERWRITE" }]</label><br />
                                </td>
                            [{else}]
                                <td>
                                    <input type="radio" id="prefix" name="jx_updmode" value="PREFIX" [{if $jx_updmode=="PREFIX"}]checked="checked"[{/if}] 
                                           onchange="document.forms.jxbulkup_update.jx_exchval.disabled=true;document.forms.jxbulkup_update.btntest.disabled=false"> 
                                    <label for="prefix">[{ oxmultilang ident="JXBULKUP_PREFIX" }]</label><br />
                                    <input type="radio" id="postfix" name="jx_updmode" value="POSTFIX" [{if $jx_updmode=="POSTFIX"}]checked="checked"[{/if}] 
                                           onchange="document.forms.jxbulkup_update.jx_exchval.disabled=true;document.forms.jxbulkup_update.btntest.disabled=false">  
                                    <label for="postfix">[{ oxmultilang ident="JXBULKUP_POSTFIX" }]</label><br />
                                    <nobr><input type="radio" id="replace" name="jx_updmode" value="REPLACE" [{if $jx_updmode=="REPLACE"}]checked="checked"[{/if}] 
                                                 onchange="document.forms.jxbulkup_update.jx_exchval.disabled=false;document.forms.jxbulkup_update.btntest.disabled=false">  
                                    <label for="replace">[{ oxmultilang ident="JXBULKUP_REPLACE" }]</label> 
                                        <input type="text" name="jx_exchval" size="10" value="[{ $jx_exchval }]"[{if $jx_updmode!="REPLACE"}]disabled="disabled"[{/if}]></nobr><br />
                                    <input type="radio" id="overwrite" name="jx_updmode" value="OVERWRITE" [{if $jx_updmode=="OVERWRITE"}]checked="checked"[{/if}] 
                                           onchange="document.forms.jxbulkup_update.jx_exchval.disabled=true;document.forms.jxbulkup_update.btntest.disabled=false">  
                                    <label for="overwrite">[{ oxmultilang ident="JXBULKUP_OVERWRITE" }]</label><br />
                                </td>
                            [{/if}]
                            <td> </td>
                        </tr>
                    </table>
                </form>
            </td>
        </tr>
    </table>

    Step="[{ $sStep }]" / Src=[{$jx_srcval}] / Act=[{$jx_active}] / Vars=[{$jx_incvars}] / Field=[{$jx_updfield}] / Attr=[{$jx_attribute}] / Upd=[{$jx_updmode}]
    
    <script type="text/javascript">
        [{if $sStep == ""}]
            disableForm('jxbulkup_display');
            disableForm('jxbulkup_update');
        [{elseif $sStep == "searchProducts"}]
            disableForm('jxbulkup_update');
        [{/if}]
    </script>
    
    <p>
    <div id="liste">
    <table cellspacing="0" cellpadding="0" border="0" width="99%">
        <tr>
            [{ assign var="headStyle" value="border-bottom:1px solid #C8C8C8; font-weight:bold;" }]
            <td valign="top" class="listfilter first" style="[{$headStyle}]" align="center">
                <div class="r1"><div class="b1">[{ oxmultilang ident="GENERAL_ACTIVTITLE" }]</div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                [{ oxmultilang ident="GENERAL_ITEMNR" }]
                </div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                [{ oxmultilang ident="GENERAL_TITLE" }]
                </div></div>
            </td>
            [{if $jx_incvars=="jx_incvars"}]
                <td class="listfilter" style="[{$headStyle}]">
                    <div class="r1"><div class="b1">
                    [{ oxmultilang ident="JXBULKUP_VARIANT" }]
                    </div></div>
                </td>
            [{/if}]
            <td class="listfilter" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                    [{if $jx_updfield=="oxartnum"}]
                        [{ oxmultilang ident="GENERAL_ITEMNR" }]
                    [{elseif $jx_updfield=="oxtitle"}]
                        [{ oxmultilang ident="GENERAL_TITLE" }]
                    [{elseif $jx_updfield=="oxvar"}]
                        [{ oxmultilang ident="JXBULKUP_VARIANT" }]
                    [{elseif $jx_updfield=="oxshortdesc"}]
                        [{ oxmultilang ident="GENERAL_SHORTDESC" }]
                    [{elseif $jx_updfield=="oxlongdesc"}]
                        [{ oxmultilang ident="ARTICLE_EXTEND_DESCRIPTION" }]
                    [{elseif $jx_updfield=="oxsearchkeys"}]
                        [{ oxmultilang ident="ARTICLE_MAIN_SEARCHKEYS" }]
                    [{elseif $jx_updfield=="oxtags"}]
                        [{ oxmultilang ident="ARTICLE_MAIN_TAGS" }]
                    [{elseif $jx_updfield=="oxdeltime"}]
                        [{ oxmultilang ident="JXBULKUP_DELTIMES" }]
                    [{elseif $jx_updfield=="oxremind"}]
                        [{ oxmultilang ident="JXBULKUP_STOCKREMINDER" }]
                    [{elseif $jx_updfield=="jxattributes"}]
                        [{ oxmultilang ident="JXBULKUP_ATTRIBUTE" }]
                    [{elseif $jx_updfield=="jxattributes"}]
                        [{ oxmultilang ident="JXBULKUP_ATTRIBUTE" }]
                    [{/if}]

                    [{if $sStep=="testUpdate"}] <span style="font-weight:bold;color:blue;">-[{ oxmultilang ident="JXBULKUP_PREVIEW" }]-</span>[{/if}]
                </div></div>
            </td>
        </tr>
        [{assign var="i" value="0"}]
        [{foreach name=outer item=Product from=$aProducts}]
            [{ cycle values="listitem,listitem2" assign="listclass" }]
            [{assign var="i" value=$i+1}]
            <tr>
                <td valign="top" class="[{$listclass}][{if $Product.oxactive == 1}] active[{/if}]" height="15">
                    <div class="listitemfloating">&nbsp</div>
                </td>
                <td class="[{ $listclass }]">&nbsp;[{ $Product.oxartnum }]</td>
                <td class="[{ $listclass }]">&nbsp;[{ $Product.oxtitle }]</td>
                [{if $jx_incvars=="jx_incvars"}]
                    <td class="[{ $listclass }]">&nbsp;[{ $Product.oxvarselect }]</td>
                [{/if}]
                [{*<td class="[{ $listclass }]">&nbsp;<span style="font-weight:bold;[{if $sStep=="testUpdate"}]color:blue;[{/if}]">[{ $Product.updfield }]</span></td>*}]
                <td class="[{ $listclass }]" style="font-weight:bold;">&nbsp;[{ $Product.updfield }]</td>
            </tr>
        [{/foreach}]
    </table>
    </div>
    </p>

</div>
</body>

[{if $sStep != ""}]
    <script>
        document.getElementById('jx_srcmsg').innerHTML='[{$i}] [{ oxmultilang ident="JXBULKUP_RECORDSFOUND" }]';
    </script>
[{/if}]
