#' define an ssrch DocSet instance using an MSigDb category
#' @importFrom xml2 read_xml xml_children xml_attr
#' @note assumes full MSigDb XML document present on disk
#' @param xmlpath character(1) path to full XML
#' @param category character(1) name of category to use
#' @param \dots passed to ssrch::parseDoc
#' @export
cat2docset = function(xmlpath, category="C7", start=1, end=10, ...) {
 xdata = read_xml(xmlpath)
 ch = xml_children(xdata)
 nch = length(ch)
 cats = sapply(1:nch, function(x)
  xml_attr(ch[[x]], "CATEGORY_CODE"))
 ok = which(cats==category)
 if (length(ok)==0) stop(sprintf("category %s not found", category))
 ch = ch[ok][start:end]
 ans = DocSet()  # start off
 od = getwd()
 on.exit(setwd(od))
 for (i in 1:length(ch)) {
  x = ch[[i]]
  tmp = geneset2DocSetElements(x)
  tf = tempdir()
  setwd(tf)
  write.csv(tmp$genedf, tt <- paste0(tmp$standard_name, ".csv"))
  ans = parseDoc(basename(tt), DocSetInstance=ans, doctitle=tmp$title, ...)
  }
  setwd(od)
  ans
}

geneset2DocSetElements = function(xmlnode) {
 title = xml_attr(xmlnode, "DESCRIPTION_BRIEF")
 abst = xml_attr(xmlnode, "DESCRIPTION_FULL")
 syms = xml_attr(xmlnode, "MEMBERS_SYMBOLIZED")
 entrez = xml_attr(xmlnode, "MEMBERS_EZID")
 sname = xml_attr(xmlnode, "STANDARD_NAME")
 syname = xml_attr(xmlnode, "SYSTEMATIC_NAME")
 syms = strsplit(syms, ",")[[1]]
 entrez = strsplit(entrez, ",")[[1]]
 recident = paste0(syname, "_", syms)
 genedf = data.frame(symbol=syms, entrez=entrez, recident=recident, stringsAsFactors=FALSE)
 list(title=title, abst=abst, genedf=genedf, standard_name=sname)
}


 
