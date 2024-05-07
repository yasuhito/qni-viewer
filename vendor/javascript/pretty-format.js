import*as t from"ansi-styles";import*as e from"react-is";var n={};Object.defineProperty(n,"__esModule",{value:true});n.printIteratorEntries=printIteratorEntries;n.printIteratorValues=printIteratorValues;n.printListItems=printListItems;n.printObjectProperties=printObjectProperties;const getKeysOfEnumerableProperties=(t,e)=>{const n=Object.keys(t);const r=null!==e?n.sort(e):n;Object.getOwnPropertySymbols&&Object.getOwnPropertySymbols(t).forEach((e=>{Object.getOwnPropertyDescriptor(t,e).enumerable&&r.push(e)}));return r};function printIteratorEntries(t,e,n,r,o,i,a=": "){let s="";let c=0;let u=t.next();if(!u.done){s+=e.spacingOuter;const l=n+e.indent;while(!u.done){s+=l;if(c++===e.maxWidth){s+="…";break}const n=i(u.value[0],e,l,r,o);const p=i(u.value[1],e,l,r,o);s+=n+a+p;u=t.next();u.done?e.min||(s+=","):s+=`,${e.spacingInner}`}s+=e.spacingOuter+n}return s}function printIteratorValues(t,e,n,r,o,i){let a="";let s=0;let c=t.next();if(!c.done){a+=e.spacingOuter;const u=n+e.indent;while(!c.done){a+=u;if(s++===e.maxWidth){a+="…";break}a+=i(c.value,e,u,r,o);c=t.next();c.done?e.min||(a+=","):a+=`,${e.spacingInner}`}a+=e.spacingOuter+n}return a}function printListItems(t,e,n,r,o,i){let a="";if(t.length){a+=e.spacingOuter;const s=n+e.indent;for(let n=0;n<t.length;n++){a+=s;if(n===e.maxWidth){a+="…";break}n in t&&(a+=i(t[n],e,s,r,o));n<t.length-1?a+=`,${e.spacingInner}`:e.min||(a+=",")}a+=e.spacingOuter+n}return a}function printObjectProperties(t,e,n,r,o,i){let a="";const s=getKeysOfEnumerableProperties(t,e.compareKeys);if(s.length){a+=e.spacingOuter;const c=n+e.indent;for(let n=0;n<s.length;n++){const u=s[n];const l=i(u,e,c,r,o);const p=i(t[u],e,c,r,o);a+=`${c+l}: ${p}`;n<s.length-1?a+=`,${e.spacingInner}`:e.min||(a+=",")}a+=e.spacingOuter+n}return a}var r={};Object.defineProperty(r,"__esModule",{value:true});r.test=r.serialize=r.default=void 0;var o=n;var i=globalThis["jest-symbol-do-not-touch"]||globalThis.Symbol;const a="function"===typeof i&&i.for?i.for("jest.asymmetricMatcher"):1267621;const s=" ";const serialize$5=(t,e,n,r,i,a)=>{const c=t.toString();if("ArrayContaining"===c||"ArrayNotContaining"===c)return++r>e.maxDepth?`[${c}]`:`${c+s}[${(0,o.printListItems)(t.sample,e,n,r,i,a)}]`;if("ObjectContaining"===c||"ObjectNotContaining"===c)return++r>e.maxDepth?`[${c}]`:`${c+s}{${(0,o.printObjectProperties)(t.sample,e,n,r,i,a)}}`;if("StringMatching"===c||"StringNotMatching"===c)return c+s+a(t.sample,e,n,r,i);if("StringContaining"===c||"StringNotContaining"===c)return c+s+a(t.sample,e,n,r,i);if("function"!==typeof t.toAsymmetricMatcher)throw new Error(`Asymmetric matcher ${t.constructor.name} does not implement toAsymmetricMatcher()`);return t.toAsymmetricMatcher()};r.serialize=serialize$5;const test$5=t=>t&&t.$$typeof===a;r.test=test$5;const c={serialize:serialize$5,test:test$5};var u=c;r.default=u;var l={};Object.defineProperty(l,"__esModule",{value:true});l.test=l.serialize=l.default=void 0;var p=n;const f=" ";const m=["DOMStringMap","NamedNodeMap"];const d=/^(HTML\w*Collection|NodeList)$/;const testName=t=>-1!==m.indexOf(t)||d.test(t);const test$4=t=>t&&t.constructor&&!!t.constructor.name&&testName(t.constructor.name);l.test=test$4;const isNamedNodeMap=t=>"NamedNodeMap"===t.constructor.name;const serialize$4=(t,e,n,r,o,i)=>{const a=t.constructor.name;return++r>e.maxDepth?`[${a}]`:(e.min?"":a+f)+(-1!==m.indexOf(a)?`{${(0,p.printObjectProperties)(isNamedNodeMap(t)?Array.from(t).reduce(((t,e)=>{t[e.name]=e.value;return t}),{}):{...t},e,n,r,o,i)}}`:`[${(0,p.printListItems)(Array.from(t),e,n,r,o,i)}]`)};l.serialize=serialize$4;const y={serialize:serialize$4,test:test$4};var g=y;l.default=g;var h={};Object.defineProperty(h,"__esModule",{value:true});h.default=escapeHTML;function escapeHTML(t){return t.replace(/</g,"&lt;").replace(/>/g,"&gt;")}var b={};Object.defineProperty(b,"__esModule",{value:true});b.printText=b.printProps=b.printElementAsLeaf=b.printElement=b.printComment=b.printChildren=void 0;var _=_interopRequireDefault$1(h);function _interopRequireDefault$1(t){return t&&t.__esModule?t:{default:t}}const printProps=(t,e,n,r,o,i,a)=>{const s=r+n.indent;const c=n.colors;return t.map((t=>{const u=e[t];let l=a(u,n,s,o,i);if("string"!==typeof u){-1!==l.indexOf("\n")&&(l=n.spacingOuter+s+l+n.spacingOuter+r);l=`{${l}}`}return`${n.spacingInner+r+c.prop.open+t+c.prop.close}=${c.value.open}${l}${c.value.close}`})).join("")};b.printProps=printProps;const printChildren=(t,e,n,r,o,i)=>t.map((t=>e.spacingOuter+n+("string"===typeof t?printText(t,e):i(t,e,n,r,o)))).join("");b.printChildren=printChildren;const printText=(t,e)=>{const n=e.colors.content;return n.open+(0,_.default)(t)+n.close};b.printText=printText;const printComment=(t,e)=>{const n=e.colors.comment;return`${n.open}\x3c!--${(0,_.default)(t)}--\x3e${n.close}`};b.printComment=printComment;const printElement=(t,e,n,r,o)=>{const i=r.colors.tag;return`${i.open}<${t}${e&&i.close+e+r.spacingOuter+o+i.open}${n?`>${i.close}${n}${r.spacingOuter}${o}${i.open}</${t}`:(e&&!r.min?"":" ")+"/"}>${i.close}`};b.printElement=printElement;const printElementAsLeaf=(t,e)=>{const n=e.colors.tag;return`${n.open}<${t}${n.close} …${n.open} />${n.close}`};b.printElementAsLeaf=printElementAsLeaf;var O={};Object.defineProperty(O,"__esModule",{value:true});O.test=O.serialize=O.default=void 0;var $=b;const v=1;const j=3;const E=8;const I=11;const M=/^((HTML|SVG)\w*)?Element$/;const testHasAttribute=t=>{try{return"function"===typeof t.hasAttribute&&t.hasAttribute("is")}catch{return false}};const testNode=t=>{const e=t.constructor.name;const{nodeType:n,tagName:r}=t;const o="string"===typeof r&&r.includes("-")||testHasAttribute(t);return n===v&&(M.test(e)||o)||n===j&&"Text"===e||n===E&&"Comment"===e||n===I&&"DocumentFragment"===e};const test$3=t=>t?.constructor?.name&&testNode(t);O.test=test$3;function nodeIsText(t){return t.nodeType===j}function nodeIsComment(t){return t.nodeType===E}function nodeIsFragment(t){return t.nodeType===I}const serialize$3=(t,e,n,r,o,i)=>{if(nodeIsText(t))return(0,$.printText)(t.data,e);if(nodeIsComment(t))return(0,$.printComment)(t.data,e);const a=nodeIsFragment(t)?"DocumentFragment":t.tagName.toLowerCase();return++r>e.maxDepth?(0,$.printElementAsLeaf)(a,e):(0,$.printElement)(a,(0,$.printProps)(nodeIsFragment(t)?[]:Array.from(t.attributes,(t=>t.name)).sort(),nodeIsFragment(t)?{}:Array.from(t.attributes).reduce(((t,e)=>{t[e.name]=e.value;return t}),{}),e,n+e.indent,r,o,i),(0,$.printChildren)(Array.prototype.slice.call(t.childNodes||t.children),e,n+e.indent,r,o,i),e,n)};O.serialize=serialize$3;const S={serialize:serialize$3,test:test$3};var P=S;O.default=P;var x={};Object.defineProperty(x,"__esModule",{value:true});x.test=x.serialize=x.default=void 0;var A=n;const T="@@__IMMUTABLE_ITERABLE__@@";const w="@@__IMMUTABLE_LIST__@@";const D="@@__IMMUTABLE_KEYED__@@";const N="@@__IMMUTABLE_MAP__@@";const C="@@__IMMUTABLE_ORDERED__@@";const R="@@__IMMUTABLE_RECORD__@@";const L="@@__IMMUTABLE_SEQ__@@";const F="@@__IMMUTABLE_SET__@@";const k="@@__IMMUTABLE_STACK__@@";const getImmutableName=t=>`Immutable.${t}`;const printAsLeaf=t=>`[${t}]`;const B=" ";const z="…";const printImmutableEntries=(t,e,n,r,o,i,a)=>++r>e.maxDepth?printAsLeaf(getImmutableName(a)):`${getImmutableName(a)+B}{${(0,A.printIteratorEntries)(t.entries(),e,n,r,o,i)}}`;function getRecordEntries(t){let e=0;return{next(){if(e<t._keys.length){const n=t._keys[e++];return{done:false,value:[n,t.get(n)]}}return{done:true,value:void 0}}}}const printImmutableRecord=(t,e,n,r,o,i)=>{const a=getImmutableName(t._name||"Record");return++r>e.maxDepth?printAsLeaf(a):`${a+B}{${(0,A.printIteratorEntries)(getRecordEntries(t),e,n,r,o,i)}}`};const printImmutableSeq=(t,e,n,r,o,i)=>{const a=getImmutableName("Seq");return++r>e.maxDepth?printAsLeaf(a):t[D]?`${a+B}{${t._iter||t._object?(0,A.printIteratorEntries)(t.entries(),e,n,r,o,i):z}}`:`${a+B}[${t._iter||t._array||t._collection||t._iterable?(0,A.printIteratorValues)(t.values(),e,n,r,o,i):z}]`};const printImmutableValues=(t,e,n,r,o,i,a)=>++r>e.maxDepth?printAsLeaf(getImmutableName(a)):`${getImmutableName(a)+B}[${(0,A.printIteratorValues)(t.values(),e,n,r,o,i)}]`;const serialize$2=(t,e,n,r,o,i)=>t[N]?printImmutableEntries(t,e,n,r,o,i,t[C]?"OrderedMap":"Map"):t[w]?printImmutableValues(t,e,n,r,o,i,"List"):t[F]?printImmutableValues(t,e,n,r,o,i,t[C]?"OrderedSet":"Set"):t[k]?printImmutableValues(t,e,n,r,o,i,"Stack"):t[L]?printImmutableSeq(t,e,n,r,o,i):printImmutableRecord(t,e,n,r,o,i);x.serialize=serialize$2;const test$2=t=>t&&(true===t[T]||true===t[R]);x.test=test$2;const U={serialize:serialize$2,test:test$2};var W=U;x.default=W;var q="default"in e?e.default:e;var V={};Object.defineProperty(V,"__esModule",{value:true});V.test=V.serialize=V.default=void 0;var K=_interopRequireWildcard(q);var J=b;function _getRequireWildcardCache(t){if("function"!==typeof WeakMap)return null;var e=new WeakMap;var n=new WeakMap;return(_getRequireWildcardCache=function(t){return t?n:e})(t)}function _interopRequireWildcard(t,e){if(!e&&t&&t.__esModule)return t;if(null===t||"object"!==typeof t&&"function"!==typeof t)return{default:t};var n=_getRequireWildcardCache(e);if(n&&n.has(t))return n.get(t);var r={};var o=Object.defineProperty&&Object.getOwnPropertyDescriptor;for(var i in t)if("default"!==i&&Object.prototype.hasOwnProperty.call(t,i)){var a=o?Object.getOwnPropertyDescriptor(t,i):null;a&&(a.get||a.set)?Object.defineProperty(r,i,a):r[i]=t[i]}r.default=t;n&&n.set(t,r);return r}const getChildren=(t,e=[])=>{Array.isArray(t)?t.forEach((t=>{getChildren(t,e)})):null!=t&&false!==t&&e.push(t);return e};const getType=t=>{const e=t.type;if("string"===typeof e)return e;if("function"===typeof e)return e.displayName||e.name||"Unknown";if(K.isFragment(t))return"React.Fragment";if(K.isSuspense(t))return"React.Suspense";if("object"===typeof e&&null!==e){if(K.isContextProvider(t))return"Context.Provider";if(K.isContextConsumer(t))return"Context.Consumer";if(K.isForwardRef(t)){if(e.displayName)return e.displayName;const t=e.render.displayName||e.render.name||"";return""!==t?`ForwardRef(${t})`:"ForwardRef"}if(K.isMemo(t)){const t=e.displayName||e.type.displayName||e.type.name||"";return""!==t?`Memo(${t})`:"Memo"}}return"UNDEFINED"};const getPropKeys$1=t=>{const{props:e}=t;return Object.keys(e).filter((t=>"children"!==t&&void 0!==e[t])).sort()};const serialize$1=(t,e,n,r,o,i)=>++r>e.maxDepth?(0,J.printElementAsLeaf)(getType(t),e):(0,J.printElement)(getType(t),(0,J.printProps)(getPropKeys$1(t),t.props,e,n+e.indent,r,o,i),(0,J.printChildren)(getChildren(t.props.children),e,n+e.indent,r,o,i),e,n);V.serialize=serialize$1;const test$1=t=>null!=t&&K.isElement(t);V.test=test$1;const H={serialize:serialize$1,test:test$1};var G=H;V.default=G;var Q={};Object.defineProperty(Q,"__esModule",{value:true});Q.test=Q.serialize=Q.default=void 0;var Y=b;var X=globalThis["jest-symbol-do-not-touch"]||globalThis.Symbol;const Z="function"===typeof X&&X.for?X.for("react.test.json"):245830487;const getPropKeys=t=>{const{props:e}=t;return e?Object.keys(e).filter((t=>void 0!==e[t])).sort():[]};const serialize=(t,e,n,r,o,i)=>++r>e.maxDepth?(0,Y.printElementAsLeaf)(t.type,e):(0,Y.printElement)(t.type,t.props?(0,Y.printProps)(getPropKeys(t),t.props,e,n+e.indent,r,o,i):"",t.children?(0,Y.printChildren)(t.children,e,n+e.indent,r,o,i):"",e,n);Q.serialize=serialize;const test=t=>t&&t.$$typeof===Z;Q.test=test;const tt={serialize:serialize,test:test};var et=tt;Q.default=et;var nt="default"in t?t.default:t;var rt={};Object.defineProperty(rt,"__esModule",{value:true});rt.default=rt.DEFAULT_OPTIONS=void 0;rt.format=format;rt.plugins=void 0;var ot=_interopRequireDefault(nt);var it=n;var at=_interopRequireDefault(r);var st=_interopRequireDefault(l);var ct=_interopRequireDefault(O);var ut=_interopRequireDefault(x);var lt=_interopRequireDefault(V);var pt=_interopRequireDefault(Q);function _interopRequireDefault(t){return t&&t.__esModule?t:{default:t}}const ft=Object.prototype.toString;const mt=Date.prototype.toISOString;const dt=Error.prototype.toString;const yt=RegExp.prototype.toString;const getConstructorName=t=>"function"===typeof t.constructor&&t.constructor.name||"Object";const isWindow=t=>"undefined"!==typeof window&&t===window;const gt=/^Symbol\((.*)\)(.*)$/;const ht=/\n/gi;class PrettyFormatPluginError extends Error{constructor(t,e){super(t);this.stack=e;this.name=this.constructor.name}}function isToStringedArrayType(t){return"[object Array]"===t||"[object ArrayBuffer]"===t||"[object DataView]"===t||"[object Float32Array]"===t||"[object Float64Array]"===t||"[object Int8Array]"===t||"[object Int16Array]"===t||"[object Int32Array]"===t||"[object Uint8Array]"===t||"[object Uint8ClampedArray]"===t||"[object Uint16Array]"===t||"[object Uint32Array]"===t}function printNumber(t){return Object.is(t,-0)?"-0":String(t)}function printBigInt(t){return String(`${t}n`)}function printFunction(t,e){return e?`[Function ${t.name||"anonymous"}]`:"[Function]"}function printSymbol(t){return String(t).replace(gt,"Symbol($1)")}function printError(t){return`[${dt.call(t)}]`}function printBasicValue(t,e,n,r){if(true===t||false===t)return`${t}`;if(void 0===t)return"undefined";if(null===t)return"null";const o=typeof t;if("number"===o)return printNumber(t);if("bigint"===o)return printBigInt(t);if("string"===o)return r?`"${t.replace(/"|\\/g,"\\$&")}"`:`"${t}"`;if("function"===o)return printFunction(t,e);if("symbol"===o)return printSymbol(t);const i=ft.call(t);return"[object WeakMap]"===i?"WeakMap {}":"[object WeakSet]"===i?"WeakSet {}":"[object Function]"===i||"[object GeneratorFunction]"===i?printFunction(t,e):"[object Symbol]"===i?printSymbol(t):"[object Date]"===i?isNaN(+t)?"Date { NaN }":mt.call(t):"[object Error]"===i?printError(t):"[object RegExp]"===i?n?yt.call(t).replace(/[\\^$*+?.()|[\]{}]/g,"\\$&"):yt.call(t):t instanceof Error?printError(t):null}function printComplexValue(t,e,n,r,o,i){if(-1!==o.indexOf(t))return"[Circular]";o=o.slice();o.push(t);const a=++r>e.maxDepth;const s=e.min;if(e.callToJSON&&!a&&t.toJSON&&"function"===typeof t.toJSON&&!i)return printer(t.toJSON(),e,n,r,o,true);const c=ft.call(t);return"[object Arguments]"===c?a?"[Arguments]":`${s?"":"Arguments "}[${(0,it.printListItems)(t,e,n,r,o,printer)}]`:isToStringedArrayType(c)?a?`[${t.constructor.name}]`:`${s?"":e.printBasicPrototype||"Array"!==t.constructor.name?`${t.constructor.name} `:""}[${(0,it.printListItems)(t,e,n,r,o,printer)}]`:"[object Map]"===c?a?"[Map]":`Map {${(0,it.printIteratorEntries)(t.entries(),e,n,r,o,printer," => ")}}`:"[object Set]"===c?a?"[Set]":`Set {${(0,it.printIteratorValues)(t.values(),e,n,r,o,printer)}}`:a||isWindow(t)?`[${getConstructorName(t)}]`:`${s?"":e.printBasicPrototype||"Object"!==getConstructorName(t)?`${getConstructorName(t)} `:""}{${(0,it.printObjectProperties)(t,e,n,r,o,printer)}}`}function isNewPlugin(t){return null!=t.serialize}function printPlugin(t,e,n,r,o,i){let a;try{a=isNewPlugin(t)?t.serialize(e,n,r,o,i,printer):t.print(e,(t=>printer(t,n,r,o,i)),(t=>{const e=r+n.indent;return e+t.replace(ht,`\n${e}`)}),{edgeSpacing:n.spacingOuter,min:n.min,spacing:n.spacingInner},n.colors)}catch(t){throw new PrettyFormatPluginError(t.message,t.stack)}if("string"!==typeof a)throw new Error(`pretty-format: Plugin must return type "string" but instead returned "${typeof a}".`);return a}function findPlugin(t,e){for(let n=0;n<t.length;n++)try{if(t[n].test(e))return t[n]}catch(t){throw new PrettyFormatPluginError(t.message,t.stack)}return null}function printer(t,e,n,r,o,i){const a=findPlugin(e.plugins,t);if(null!==a)return printPlugin(a,t,e,n,r,o);const s=printBasicValue(t,e.printFunctionName,e.escapeRegex,e.escapeString);return null!==s?s:printComplexValue(t,e,n,r,o,i)}const bt={comment:"gray",content:"reset",prop:"yellow",tag:"cyan",value:"green"};const _t=Object.keys(bt);const toOptionsSubtype=t=>t;const Ot=toOptionsSubtype({callToJSON:true,compareKeys:void 0,escapeRegex:false,escapeString:true,highlight:false,indent:2,maxDepth:Infinity,maxWidth:Infinity,min:false,plugins:[],printBasicPrototype:true,printFunctionName:true,theme:bt});rt.DEFAULT_OPTIONS=Ot;function validateOptions(t){Object.keys(t).forEach((t=>{if(!Object.prototype.hasOwnProperty.call(Ot,t))throw new Error(`pretty-format: Unknown option "${t}".`)}));if(t.min&&void 0!==t.indent&&0!==t.indent)throw new Error('pretty-format: Options "min" and "indent" cannot be used together.');if(void 0!==t.theme){if(null===t.theme)throw new Error('pretty-format: Option "theme" must not be null.');if("object"!==typeof t.theme)throw new Error(`pretty-format: Option "theme" must be of type "object" but instead received "${typeof t.theme}".`)}}const getColorsHighlight=t=>_t.reduce(((e,n)=>{const r=t.theme&&void 0!==t.theme[n]?t.theme[n]:bt[n];const o=r&&ot.default[r];if(!o||"string"!==typeof o.close||"string"!==typeof o.open)throw new Error(`pretty-format: Option "theme" has a key "${n}" whose value "${r}" is undefined in ansi-styles.`);e[n]=o;return e}),Object.create(null));const getColorsEmpty=()=>_t.reduce(((t,e)=>{t[e]={close:"",open:""};return t}),Object.create(null));const getPrintFunctionName=t=>t?.printFunctionName??Ot.printFunctionName;const getEscapeRegex=t=>t?.escapeRegex??Ot.escapeRegex;const getEscapeString=t=>t?.escapeString??Ot.escapeString;const getConfig=t=>({callToJSON:t?.callToJSON??Ot.callToJSON,colors:t?.highlight?getColorsHighlight(t):getColorsEmpty(),compareKeys:"function"===typeof t?.compareKeys||null===t?.compareKeys?t.compareKeys:Ot.compareKeys,escapeRegex:getEscapeRegex(t),escapeString:getEscapeString(t),indent:t?.min?"":createIndent(t?.indent??Ot.indent),maxDepth:t?.maxDepth??Ot.maxDepth,maxWidth:t?.maxWidth??Ot.maxWidth,min:t?.min??Ot.min,plugins:t?.plugins??Ot.plugins,printBasicPrototype:t?.printBasicPrototype??true,printFunctionName:getPrintFunctionName(t),spacingInner:t?.min?" ":"\n",spacingOuter:t?.min?"":"\n"});function createIndent(t){return new Array(t+1).join(" ")}
/**
 * Returns a presentation string of your `val` object
 * @param val any potential JavaScript object
 * @param options Custom settings
 */function format(t,e){if(e){validateOptions(e);if(e.plugins){const n=findPlugin(e.plugins,t);if(null!==n)return printPlugin(n,t,getConfig(e),"",0,[])}}const n=printBasicValue(t,getPrintFunctionName(e),getEscapeRegex(e),getEscapeString(e));return null!==n?n:printComplexValue(t,getConfig(e),"",0,[])}const $t={AsymmetricMatcher:at.default,DOMCollection:st.default,DOMElement:ct.default,Immutable:ut.default,ReactElement:lt.default,ReactTestComponent:pt.default};rt.plugins=$t;var vt=format;rt.default=vt;const jt=rt.__esModule;const Et=rt.DEFAULT_OPTIONS,It=rt.format,Mt=rt.plugins;export{Et as DEFAULT_OPTIONS,jt as __esModule,rt as default,It as format,Mt as plugins};

