<?php

/*
 *    This file is part of the module jxExcptns for OXID eShop Community Edition.
 *
 *    The module OxProbs for OXID eShop Community Edition is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    The module OxProbs for OXID eShop Community Edition is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with OXID eShop Community Edition.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @link      https://github.com/job963/jxExcptns
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 * @copyright (C) Joachim Barthel 2012-2013
 *
 */
 
class jxbulkup extends oxAdminView
{
    protected $_sThisTemplate = "jxbulkup.tpl";
    public function render()
    {
        parent::render();
        $oSmarty = oxUtilsView::getInstance()->getSmarty();
        $oSmarty->assign( "oViewConf", $this->_aViewData["oViewConf"]);
        $oSmarty->assign( "shop", $this->_aViewData["shop"]);
        /*$oLang = oxLang::getInstance();
        $iLang = $oLang->getTplLanguage();*/
        //$myConfig = oxRegistry::get("oxConfig");
        
        $sStep = oxConfig::getParameter( 'step' );
        $sSrcVal = oxConfig::getParameter( 'jx_srcval' );
        $sActive = oxConfig::getParameter( 'jx_active' );
        $sIncVars = oxConfig::getParameter( 'jx_incvars' );
        $sUpdField = oxConfig::getParameter( 'jx_updfield' );
        $sAttribute = oxConfig::getParameter( 'jx_attribute' );
        $sUpdVal = oxConfig::getParameter( 'jx_updval' );
        $sUpdValMin = oxConfig::getParameter( 'jx_updval_min' );
        $sUpdValMax = oxConfig::getParameter( 'jx_updval_max' );
        $sUpdValUnit = oxConfig::getParameter( 'jx_updval_unit' );
        $sUpdValRemind = oxConfig::getParameter( 'jx_updval_remind' );
        $sUpdValMode = oxConfig::getParameter( 'jx_updval_mode' );
        $sExchVal = oxConfig::getParameter( 'jx_exchval' );
        $sUpdMode = oxConfig::getParameter( 'jx_updmode' );

        $aProducts = array();
        $aAttributes = array();
        
        $aAttributes = $this->_retrieveAttributes();
        
        //echo $sStep;
        if (empty($sStep)) {
            $sActive = "jx_active";     // only active products
            $sIncVars = "";             // excl. variants
        }
        
        if ($sStep == 'searchProducts') 
            $aProducts = $this->_retrieveSearchResults('');

        if ($sStep == 'displayUpdateField') {
            //$sUpdate = oxConfig::getParameter( 'jx_updfield' );
            $sUpdate = $this->_createSourceColumn();
            $aProducts = $this->_retrieveSearchResults($sUpdate);
        }

        if ($sStep == 'testUpdate') {
            $sUpdate = $this->_createPreviewColumn();
            $aProducts = $this->_retrieveSearchResults($sUpdate);
        }

        if ($sStep == 'executeUpdate') {
            $sUpdate = $this->_createUpdateSet();
            $this->_executeUpdate($sUpdate);

            //$sUpdate = oxConfig::getParameter( 'jx_updfield' );
            $sUpdate = $this->_createSourceColumn();
            $aProducts = $this->_retrieveSearchResults($sUpdate);
        }
        
        $oSmarty->assign("sStep",$sStep);
        $oSmarty->assign("jx_srcval",$sSrcVal);
        $oSmarty->assign("jx_active",$sActive);
        $oSmarty->assign("jx_incvars",$sIncVars);
        $oSmarty->assign("jx_updfield",$sUpdField);
        $oSmarty->assign("jx_attribute",$sAttribute);
        $oSmarty->assign("jx_updval",$sUpdVal);
        $oSmarty->assign("jx_updval_min",$sUpdValMin);
        $oSmarty->assign("jx_updval_max",$sUpdValMax);
        $oSmarty->assign("jx_updval_unit",$sUpdValUnit);
        $oSmarty->assign("jx_updval_remind",$sUpdValRemind);
        $oSmarty->assign("jx_updval_mode",$sUpdValMode);
        $oSmarty->assign("jx_exchval",$sExchVal);
        $oSmarty->assign("jx_updmode",$sUpdMode);
        $oSmarty->assign("aProducts",$aProducts);
        $oSmarty->assign("aAttributes",$aAttributes);

        return $this->_sThisTemplate;
    }
    
    
    private function _retrieveSearchResults($sUpdateField)
    {
        $sSrcVal = oxConfig::getParameter( 'jx_srcval' );
        $sActive = oxConfig::getParameter( 'jx_active' );
        $sIncVars = oxConfig::getParameter( 'jx_incvars' );
        $sAttribute = oxConfig::getParameter( 'jx_attribute' );
        //echo "sUpdateField:$sUpdateField<br>";
        
        if (empty($sUpdateField))
            $sUpdateField = "''";
        /*else if (strpos(' oxartnum oxtitle oxshortdesc oxsearchkeys', $sUpdateField)>0)
            $sUpdateField = 'a.' . $sUpdateField;
        else if (strpos(' oxlongdesc oxtags', $sUpdateField)>0)
            $sUpdateField = 'e.' . $sUpdateField;
        else if (strpos(' oxdeltime', $sUpdateField)>0)
            $sUpdateField = "CONCAT(a.oxmindeltime,' - ',a.oxmaxdeltime, ' ',a.oxdeltimeunit)";
        else if (strpos(' oxremind', $sUpdateField)>0)
            $sUpdateField = "IF(a.oxremindactive=1,CONCAT('aktiv, mind. ',a.oxremindamount),'inaktiv')";
        else if (strpos(' jxattributes', $sUpdateField)>0)
            $sUpdateField = "(SELECT v.oxvalue FROM oxobject2attribute v WHERE oxobjectid=a.oxid AND oxattrid='$sAttribute' )";/* */
        //echo "sUpdateField:$sUpdateField<br>";
        
        $sWhere = '';
        if (!empty($sActive))
            $sWhere .= "AND a.oxactive = 1 ";
        if (empty($sIncVars))
            $sWhere .= "AND a.oxparentid = '' ";
            
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        
        $sSql = "SELECT a.oxid, a.oxactive, a.oxartnum, "
                    ."IF(a.oxparentid='',a.oxtitle, (SELECT b.oxtitle FROM oxarticles b WHERE a.oxparentid=b.oxid)) AS oxtitle, "
                    . "a.oxvarselect, $sUpdateField AS updfield "
                . "FROM oxarticles a, oxartextends e "
                . "WHERE ("
                        . "UPPER(a.oxartnum) LIKE '%$sSrcVal%' "
                        . "OR IF(a.oxparentid='',UPPER(a.oxtitle), (SELECT UPPER(b.oxtitle) FROM oxarticles b WHERE a.oxparentid=b.oxid)) LIKE '%$sSrcVal%' "
                        . "OR UPPER(a.oxvarselect) LIKE '%$sSrcVal%' "
                        . "OR UPPER(a.oxsearchkeys) LIKE '%$sSrcVal%' "
                        . "OR a.oxean LIKE '%$sSrcVal%') "
                    . "AND a.oxid = e.oxid "
                    . $sWhere
                . "ORDER BY IF(a.oxparentid='',a.oxtitle, (SELECT b.oxtitle FROM oxarticles b WHERE a.oxparentid=b.oxid)), a.oxvarselect ";
        
        echo '<pre>'.$sSql.'</pre>';
        $rs = $oDb->Execute($sSql);

        $aProducts = array();

        //if ($sSrcVal != "") {
            $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
            $rs = $oDb->Execute($sSql);
            while (!$rs->EOF) {
                array_push($aProducts, $rs->fields);
                $rs->MoveNext();
            }
        //}
        /*echo '<pre>';
        print_r($aProducts);
        echo '</pre>'; /* */

        echo "sUpdateField=".$sUpdateField;
        //strpos(' oxlongdesc oxtags', $sUpdateField)>0
        //if ($sUpdateField == 'a.oxprice') {
        if ( strpos($sUpdateField,'oxprice') > 0 ) {
            $oCur = $this->getConfig()->getActShopCurrencyObject();
            $oLang = oxRegistry::getLang();
            foreach ($aProducts as $key => $value) {
                $aProducts[$key]['updfield'] = $oLang->formatCurrency( $aProducts[$key]['updfield'], $oCur ) . ' ' . $oCur->name;
            }
        }
        
        return $aProducts;
    }

    
    private function _executeUpdate($sUpdateFields)
    {
        $sUpdateField = oxConfig::getParameter( 'jx_updfield' );
        $sSrcVal = oxConfig::getParameter( 'jx_srcval' );
        $sAttribute = oxConfig::getParameter( 'jx_attribute' );
        $sUpdateValue = oxConfig::getParameter( 'jx_updval' );
        $sExchangeValue = oxConfig::getParameter( 'jx_exchval' );
        $sUpdateMode = oxConfig::getParameter( 'jx_updmode' );
        $sActive = oxConfig::getParameter( 'jx_active' );
        $sIncVars = oxConfig::getParameter( 'jx_incvars' );
        
        if (strpos(' oxartnum oxtitle oxshortdesc oxsearchkeys', $sUpdateField) > 0)
            $sUpdateTable = 'oxarticles';
        else if (strpos(' oxlongdesc oxtags', $sUpdateField) > 0)
            $sUpdateTable = 'oxartextends';
        else if (strpos(' oxdeltime', $sUpdateField) > 0) 
            $sUpdateTable = 'oxarticles';
        else if (strpos(' oxremind', $sUpdateField) > 0)
            $sUpdateTable = 'oxarticles';
        else if (strpos(' jxattributes', $sUpdateField) > 0)
            $sUpdateTable = 'oxobject2attribute t';
        
        $sWhere = '';
        if (!empty($sActive))
            $sWhere .= "AND oxarticles.oxactive = 1 ";
        if (empty($sIncVars))
            $sWhere .= "AND oxarticles.oxparentid = '' ";
        
        $sSql = "UPDATE $sUpdateTable "
                . "SET $sUpdateFields "
                . "WHERE ("
                        . "UPPER(oxarticles.oxartnum) LIKE '%$sSrcVal%' "
                        //. "OR IF(a.oxparentid='',UPPER(a.oxtitle), (SELECT UPPER(b.oxtitle) FROM oxarticles b WHERE a.oxparentid=b.oxid)) LIKE '%$sSrcVal%' "
                        . "OR UPPER(oxarticles.oxvarselect) LIKE '%$sSrcVal%' "
                        . "OR UPPER(oxarticles.oxsearchkeys) LIKE '%$sSrcVal%' "
                        . "OR oxarticles.oxean LIKE '%$sSrcVal%') "
                    . $sWhere;
                
        echo '<pre>'.$sSql.'</pre>';
        $oDb = oxDb::getDb();
        $ret = $oDb->Execute($sSql);
        //echo '<pre>ret='.$ret.'</pre>';
        
        return;
    }
    
    
    private function _retrieveAttributes()
    {
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        $sSql = "SELECT oxid, oxtitle FROM oxattribute a ORDER BY oxtitle";
        
        $rs = $oDb->Execute($sSql);
        $aAttributes = array();
        
        while (!$rs->EOF) {
            array_push($aAttributes, $rs->fields);
            $rs->MoveNext();
        }
        
        return $aAttributes;
    }
    
    
    private function _createSourceColumn()
    {
        $sUpdateField = oxConfig::getParameter( 'jx_updfield' );
        $sAttribute = oxConfig::getParameter( 'jx_attribute' );
        $myConfig = oxRegistry::get("oxConfig");
        $oCurrency = $myConfig->getActShopCurrencyObject();
        $sCurrency = $oCurrency->sign;
        
        if (empty($sUpdateField))
            $sUpdateField = "''";
        else if (strpos(' oxartnum oxtitle oxshortdesc oxsearchkeys', $sUpdateField) > 0)
            $sUpdateField = 'a.' . $sUpdateField;
        else if (strpos(' oxlongdesc oxtags', $sUpdateField) > 0)
            $sUpdateField = 'e.' . $sUpdateField;
        else if (strpos(' oxdeltime', $sUpdateField) > 0) {
            $sUpdateField = "CONCAT(a.oxmindeltime,' - ',a.oxmaxdeltime, ' ',a.oxdeltimeunit)";
            $sUpdateValue = oxConfig::getParameter( 'jx_updval_min' ) . ' - '
                          . oxConfig::getParameter( 'jx_updval_max' ) . ' '
                          . oxConfig::getParameter( 'jx_updval_unit' );
        }
        else if (strpos(' oxremind', $sUpdateField) > 0) {
            $sTransActive = oxLang::getInstance()->translateString('JXBULKUP_ACTIVE' );
            $sTransInactive = oxLang::getInstance()->translateString('JXBULKUP_INACTIVE' );
            $sTransMinimum = oxLang::getInstance()->translateString('JXBULKUP_MINIMUM' );
            $sUpdateField = "IF(a.oxremindactive=1,CONCAT('{$sTransActive}, {$sTransMinimum} ',a.oxremindamount),'{$sTransInactive}')";
        }
        else if (strpos(' jxattributes', $sUpdateField) > 0)
            $sUpdateField = "(SELECT v.oxvalue FROM oxobject2attribute v WHERE oxobjectid=a.oxid AND oxattrid='$sAttribute' )";
        else if (strpos(' oxprice', $sUpdateField) > 0) 
            $sUpdateField = 'a.' . $sUpdateField;
        
        
        return $sUpdateField;
    }
    
    
    private function _createPreviewColumn()
    {
        $sUpdateField = oxConfig::getParameter( 'jx_updfield' );
        //$sAttribute = oxConfig::getParameter( 'jx_attribute' );
        $sExchangeValue = oxConfig::getParameter( 'jx_exchval' );
        $sUpdateMode = oxConfig::getParameter( 'jx_updmode' );
        $sUpdateValMode = oxConfig::getParameter( 'jx_updval_mode' );
        
        $sUpdateValue = mysql_real_escape_string( oxConfig::getParameter( 'jx_updval' ) );
        
        if (strpos(' oxdeltime', $sUpdateField) > 0)
            $sUpdateValue = oxConfig::getParameter( 'jx_updval_min' ) . ' - '
                          . oxConfig::getParameter( 'jx_updval_max' ) . ' '
                          . oxConfig::getParameter( 'jx_updval_unit' );
        
        if (strpos(' oxremind', $sUpdateField) > 0) {
            $sTransActive = oxLang::getInstance()->translateString('JXBULKUP_ACTIVE' );
            $sTransInactive = oxLang::getInstance()->translateString('JXBULKUP_INACTIVE' );
            $sTransMinimum = oxLang::getInstance()->translateString('JXBULKUP_MINIMUM' );
            if (oxConfig::getParameter('jx_updval_remind') == 'jx_updval_remind')
                $sUpdateValue = "{$sTransActive}, {$sTransMinimum} " . oxConfig::getParameter('jx_updval_min');
            else
                $sUpdateValue = "{$sTransInactive}";
        }
        
        $sUpdateField = $this->_createSourceColumn();
        
        switch ($sUpdateMode) {
            case 'PREFIX':
                $sUpdateField = "CONCAT('<span style=\"color:blue;\">$sUpdateValue</span>',$sUpdateField)";
                break;
            case 'POSTFIX':
                $sUpdateField = "CONCAT($sUpdateField,'<span style=\"color:blue;\">$sUpdateValue</span>')";
                break;
            case 'REPLACE':
                $sUpdateField = "REPLACE($sUpdateField,'$sExchangeValue','<span style=\"color:blue;\">$sUpdateValue</span>')";
                break;
            case 'OVERWRITE':
                $sUpdateField = "'<span style=\"color:blue;\">{$sUpdateValue}</span>'";
                break;
            case 'INCREASE':
                if ($sUpdateValMode == 'ABS')
                    $sUpdateField = "$sUpdateField+$sUpdateValue";
                else // PERC
                    $sUpdateField = "$sUpdateField*(100.0+$sUpdateValue)/100.0";
                break;
            case 'DECREASE':
                if ($sUpdateValMode == 'ABS')
                    $sUpdateField = "$sUpdateField-$sUpdateValue";
                else // PERC
                    $sUpdateField = "$sUpdateField*(100.0-$sUpdateValue)/100.0";
                break;
        }
        
        return $sUpdateField;
    }
    
    
    /*private function _createUpdateField()
    {
        
    }*/
    
    
    private function _createUpdateSet()
    {
        $sStep = oxConfig::getParameter( 'step' );
        $sUpdateField = oxConfig::getParameter( 'jx_updfield' );
        $sAttribute = oxConfig::getParameter( 'jx_attribute' );
        $sExchangeValue = oxConfig::getParameter( 'jx_exchval' );
        $sUpdateMode = oxConfig::getParameter( 'jx_updmode' );
        
        if (strpos(' oxdeltime', $sUpdateField) > 0) {
            $sUpdateValue = array();
            $sUpdateValue[0] = oxConfig::getParameter( 'jx_updval_min' );
            $sUpdateValue[1] = oxConfig::getParameter( 'jx_updval_max' );
            $sUpdateValue[2] = oxConfig::getParameter( 'jx_updval_unit' );
        }
        elseif (strpos(' oxremind', $sUpdateField) > 0) {
            $sUpdateValue = array();
            if (oxConfig::getParameter('jx_updval_remind') == 'jx_updval_remind' ) {
                $sUpdateValue[0] = '1';
                $sUpdateValue[1] = oxConfig::getParameter('jx_updval_min');
            }
            else {
                $sUpdateValue[0] = '0';
                $sUpdateValue[1] = '0';
            }
        }
        else
            $sUpdateValue = mysql_real_escape_string( oxConfig::getParameter( 'jx_updval' ) );
        
        if (empty($sUpdateField))
            $sUpdateField = "''";
        else if (strpos(' oxartnum oxtitle oxshortdesc oxsearchkeys', $sUpdateField)>0)
            $sUpdateField = 'oxarticles.' . $sUpdateField;
        else if (strpos(' oxlongdesc oxtags', $sUpdateField)>0)
            $sUpdateField = 'oxartextends.' . $sUpdateField;
        /*else if (strpos(' oxdeltime', $sUpdateField)>0) 
            $sUpdateField = "CONCAT(a.oxmindeltime,' - ',a.oxmaxdeltime, ' ',a.oxdeltimeunit)";
        else if (strpos(' oxremind', $sUpdateField)>0)
            $sUpdateField = "IF(a.oxremindactive=1,CONCAT('aktiv, mind. ',a.oxremindamount),'inaktiv')";*/
        else if (strpos(' jxattributes', $sUpdateField)>0)
            $sUpdateField = "(SELECT v.oxvalue FROM oxobject2attribute v WHERE oxobjectid=a.oxid AND oxattrid='$sAttribute' )";

        switch ($sUpdateMode) {
            case 'PREFIX':
                $sUpdateSet = "$sUpdateField = CONCAT('{$sUpdateValue}',$sUpdateField)";
                break;
            case 'POSTFIX':
                $sUpdateSet = "$sUpdateField = CONCAT($sUpdateField,'{$sUpdateValue}')";
                break;
            case 'REPLACE':
                $sUpdateSet = "$sUpdateField = REPLACE($sUpdateField,'$sExchangeValue','{$sUpdateValue}')";
                break;
            case 'OVERWRITE':
                if (strpos(' oxdeltime', $sUpdateField)>0) 
                    $sUpdateSet = "oxarticles.oxmindeltime={$sUpdateValue[0]}, "
                                . "oxarticles.oxmaxdeltime={$sUpdateValue[1]}, "
                                . "oxarticles.oxdeltimeunit='{$sUpdateValue[2]}' ";
                elseif (strpos(' oxremind', $sUpdateField)>0) 
                    $sUpdateSet = "oxarticles.oxremindactive={$sUpdateValue[0]}, "
                                . "oxarticles.oxremindamount={$sUpdateValue[1]} ";
                else
                    $sUpdateSet = "$sUpdateField = '{$sUpdateValue}' ";
                break;
        }
        echo '<pre>'.$sUpdateField.'/'.$sUpdateSet.'</pre>';
            
        return $sUpdateSet;
    }

    
}
?>