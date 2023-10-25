xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare function local:getInfo($sourceId as xs:string, $item as node(), $listBibl as node()) as node() {
    let $bibl := $listBibl/tei:bibl[tei:citedRange[@xml:id=$sourceId]]
    
    let $wholeText :=   if (exists($bibl/tei:citedRange[@xml:id=$sourceId and @wholeText='yes'])) then
                            "yes"
                        else
                            "no"
    let $wholePeriodical :=   if (exists($bibl/tei:citedRange[@xml:id=$sourceId and @wholePeriodical='yes'])) then
                            "yes"
                        else
                            "no"

    let $source :=  if ($wholeText = "yes") then
                        $sourceId
                    else if ($wholePeriodical = "yes") then
                        translate($bibl/tei:title[@level="j"]/@key, '#', '')
                    else if (exists($bibl/tei:citedRange[@wholeText='yes'])) then
                        $bibl/tei:citedRange[@wholeText='yes']/@xml:id
                    else
                        $bibl/@xml:id
                            
    let $refInt :=   if (exists($bibl/tei:citedRange[@xml:id=$sourceId and tei:ref[@type='int']])) then
                            translate($bibl/tei:citedRange[@xml:id=$sourceId]/tei:ref[@type='int']/@target, '#', '')
                            (: "yes":)
                        else
                            "no"
                            
    let $refIntSubtype :=   if (exists($bibl/tei:citedRange[@xml:id=$sourceId and tei:ref[@type='int']])) then
                                $bibl/tei:citedRange[@xml:id=$sourceId]/tei:ref[@type='int']/@subtype
                            else
                                "no" 
    let $refLevel :=    if ($refInt = 'no') then
                            "no"
                        else (
                            let $citedRange := $listBibl/tei:bibl/tei:citedRange[@xml:id=$refInt]
                            return if ($citedRange[@wholeText="yes"]) then
                                        "text"
                                    else if ($citedRange[@wholePeriodical="yes"]) then
                                        "periodical"
                                    else
                                        "no"
                        )
                            
    let $posCitedRange :=  count($bibl/tei:citedRange[@xml:id=$sourceId]/preceding-sibling::tei:citedRange) + 1
    
    (:  - "@refPos" für die Position des citedRange, das in @refInt referenziert wird. :)
    let $refPos :=  if ($refInt = "no") then
                        "no"
                    else (
                        let $refBibl := $listBibl/tei:bibl[tei:citedRange[@xml:id=$refInt]]
                        return count($refBibl/tei:citedRange[@xml:id=$refInt]/preceding-sibling::tei:citedRange) + 1
                    )
    
    (:  - "@refBase" für die Basis-ID des in @refInt referenzierten citedRange. :)
    let $refBase := if ($refInt = "no") then
                        "no"
                    else (
                        let $refBibl := $listBibl/tei:bibl[tei:citedRange[@xml:id=$refInt]]
                        let $citedRange := $refBibl/tei:citedRange[@xml:id=$refInt]
                        return  if ($citedRange[@wholeText = "yes"]) then
                                    $refInt
                                else if ($citedRange[@wholePeriodical = "yes"]) then(
                                    translate($refBibl/tei:title[@level="j"]/@key, '#', ''))
                                else if (exists($refBibl/tei:citedRange[@wholeText='yes'])) then
                                    $refBibl/tei:citedRange[@wholeText='yes']/@xml:id
                                else
                                    $refBibl/@xml:id
                    )

    (:  - "@refInt2" für das @target aus dem ref[@type="int"] im in @refInt referenzierten citedRange; gibt's keines, 
            dann gibt's das Attribut nicht und diese nächsten auch nicht:)
    let $refInt2 := if ($refInt = "no") then
                        "no"
                    else if (exists($listBibl/tei:bibl/tei:citedRange[@xml:id=$refInt and tei:ref[@type='int']])) then
                        translate($listBibl/tei:bibl/tei:citedRange[@xml:id=$refInt]/tei:ref[@type='int']/@target, '#', '')
                    else
                        "no"
                        
    (:  - "@refIntSubtype2" für den @subtype aus dem ref[@type="int"] im in @refInt referenzierten citedRange :)
    let $refIntSubtype2 :=  if ($refInt = "no") then
                                "no"
                            else if (exists($listBibl/tei:bibl/tei:citedRange[@xml:id=$refInt and tei:ref[@type='int']])) then
                                $listBibl/tei:bibl/tei:citedRange[@xml:id=$refInt]/tei:ref[@type='int']/@subtype
                            else
                                "no" 
    (:  - "@refLevel2" für @wholeText bzw. @wholePeriodical in dem citedRange, das in @refInt2 referenziert wird :)
    let $refLevel2 :=   if ($refInt2 = 'no') then
                            "no"
                        else (
                            let $citedRange := $listBibl/tei:bibl/tei:citedRange[@xml:id=$refInt2]
                            return if ($citedRange[@wholeText="yes"]) then
                                        "text"
                                    else if ($citedRange[@wholePeriodical="yes"]) then
                                        "periodical"
                                    else
                                        "no"
                        )

    (:  - "@refPos2" für die Position des citedRange, das in @refInt2 referenziert wird :)
                                (:  - "@refPos" für die Position des citedRange, das in @refInt referenziert wird. :)
    let $refPos2 :=  if ($refInt2 = "no") then
                        "no"
                    else (
                        let $refBibl := $listBibl/tei:bibl[tei:citedRange[@xml:id=$refInt2]]
                        return count($refBibl/tei:citedRange[@xml:id=$refInt2]/preceding-sibling::tei:citedRange) + 1  
                    )

    (:  - "@refBase2" für die Basis-ID des im @refInt2 referenzierten citedRange :)
    let $refBase2 :=    if ($refInt2 = "no") then
                            "no"
                        else (
                            let $refBibl := $listBibl/tei:bibl[tei:citedRange[@xml:id=$refInt2]]
                            let $citedRange := $refBibl/tei:citedRange[@xml:id=$refInt2]
                            return  if ($citedRange[@wholeText = "yes"]) then
                                        $refInt2
                                    else if ($citedRange[@wholePeriodical = "yes"]) then(
                                        translate($refBibl/tei:title[@level="j"]/@key, '#', ''))
                                    else if (exists($refBibl/tei:citedRange[@wholeText='yes'])) then
                                        $refBibl/tei:citedRange[@wholeText='yes']/@xml:id
                                    else 
                                        $refBibl/@xml:id
                        )

    return 
            <info source="{$source}" wholeText="{$wholeText}" wholePeriodical="{$wholePeriodical}"  posCitedRange="{$posCitedRange}" refInt="{$refInt}" refIntSubtype="{$refIntSubtype}" refLevel="{$refLevel}" refPos="{$refPos}" refBase="{$refBase}" refInt2="{$refInt2}" refIntSubtype2="{$refIntSubtype2}" refLevel2="{$refLevel2}" refPos2="{$refPos2}" refBase2="{$refBase2}"/>
};


let $items := doc("/db/dw/xml/quote_permalinks_2023_04.xml")//item
let $listBibl := doc("/db/dw/xml/listbibl.xml")//tei:listBibl
return 
    <result>
         {
            for $item in subsequence($items, 1, 3311)
                return 
                    <item>
                        {$item/*}
                        {
                            for $sourceId in $item/source/tokenize(., " ") 
                                let $sourceIdNoHash := translate($sourceId, '#', '')
                                return local:getInfo($sourceIdNoHash, $item, $listBibl)
                        }
                    </item>
         }
    </result>