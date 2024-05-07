import e from"fraction.js";import{format as t}from"pretty-format";function D(t){let r=l(t);return new e(r).valueOf()*Math.PI}function q(e){let t=l(e).split("/");if(1===t.length)return 1;if(2===t.length)return parseInt(t[1]);throw new Error(`Failed to parse angle '${e}'`)}function O(e){let t=l(e).split("/");if(1===t.length)return parseInt(t[0]);if(2===t.length)return parseInt(t[0]);throw new Error(`Failed to parse angle '${e}'`)}function U(t,r){return new e(l(t)).valueOf()<new e(l(r)).valueOf()}function B(t,r){return new e(l(t)).valueOf()>new e(l(r)).valueOf()}function $(t){if("0"===t)return!0;if(!/π/.test(t))return!1;try{let r=l(t);return new e(r).valueOf(),!0}catch(e){return!1}}function l(e){return e.replace(/(\d+)π/g,"$1").replace(/π/g,"1")}function P(t){try{let r,a=l(t),i=new e(a).toFraction().split("/");return r="0"===i[0]?"0":"1"===i[0]?"π":"-1"===i[0]?"-π":`${i[0]}π`,1===i.length?r:`${r}/${i[1]}`}catch(e){throw new Error(`Failed to parse angle '${t}'`)}}var r=0,a=class extends Error{constructor(e,a){super(e);this.detailsObj=a,this.name="Error",this.message=e,this.stack=(new Error).stack,void 0!==this.stack&&(this.stack=this.stack.replace(/^Error\n\s+at new DetailedError (\S+)\s?\n\s+at /,"\n    ")),r++;try{this.details=1===r?t(this.detailsObj):"(failed to prettyFormat detailsObj due to possibly re-entrancy)"}catch(e){console.error(e),this.details="(failed to prettyFormat detailsObj, see the console for details)"}finally{r--}}};var i=[{character:"½",ref:"½",expanded:"1/2",value:.5},{character:"¼",ref:"¼",expanded:"1/4",value:.25},{character:"¾",ref:"¾",expanded:"3/4",value:.75},{character:"⅓",ref:"⅓",expanded:"1/3",value:.3333333333333333},{character:"⅔",ref:"⅔",expanded:"2/3",value:.6666666666666666},{character:"⅕",ref:"⅕",expanded:"1/5",value:.2},{character:"⅖",ref:"⅖",expanded:"2/5",value:.4},{character:"⅗",ref:"⅗",expanded:"3/5",value:.6},{character:"⅘",ref:"⅘",expanded:"4/5",value:.8},{character:"⅙",ref:"⅙",expanded:"1/6",value:.16666666666666666},{character:"⅚",ref:"⅚",expanded:"5/6",value:.8333333333333334},{character:"⅐",ref:"⅐",expanded:"1/7",value:.14285714285714285},{character:"⅛",ref:"⅛",expanded:"1/8",value:.125},{character:"⅜",ref:"⅜",expanded:"3/8",value:.375},{character:"⅝",ref:"⅝",expanded:"5/8",value:.625},{character:"⅞",ref:"⅞",expanded:"7/8",value:.875},{character:"⅑",ref:"⅑",expanded:"1/9",value:.1111111111111111},{character:"⅒",ref:"⅒",expanded:"1/10",value:.1}],n=class{static parseFloat(e){if(0===e.length)throw new Error(`Not a number: '${e}'`);if("-"===e[0])return-n.parseFloat(e.substr(1));if("√"===e[0])return Math.sqrt(n.parseFloat(e.substr(1)));let t=n.matchUnicodeFraction((t=>t.character===e));if(void 0!==t)return t.value;let r=parseFloat(e);if(isNaN(r))throw new Error(`Not a number: '${e}'`);return r}static simplifyByRounding(e,t){if(e<0)return-n.simplifyByRounding(-e,t);let r=e%1;if(r<=t||1-r<=t)return Math.round(e);let a=n.matchUnicodeFraction((r=>Math.abs(r.value-e)<=t));if(void 0!==a)return a.value;let i=n.matchUnicodeFraction((r=>Math.abs(Math.sqrt(r.value)-e)<=t));return void 0!==i?Math.sqrt(i.value):e}static matchUnicodeFraction(e){for(let t of i)if(e(t))return t}constructor(e,t,r,a){this.allowAbbreviation=e,this.maxAbbreviationError=t,this.fixedDigits=r,this.itemSeparator=a}formatFloat(e){return this.allowAbbreviation?this.abbreviateFloat(e,this.maxAbbreviationError,this.fixedDigits):void 0!==this.fixedDigits?e.toFixed(this.fixedDigits):String(e)}abbreviateFloat(e,t=0,r){if(Math.abs(e)<t)return"0";if(e<0)return`-${this.abbreviateFloat(-e,t,r)}`;let a=n.matchUnicodeFraction((r=>Math.abs(r.value-e)<=t));if(void 0!==a)return a.character;let i=n.matchUnicodeFraction((r=>Math.abs(Math.sqrt(r.value)-e)<=t));return void 0!==i?`√${i.character}`:e%1!==0&&void 0!==r?e.toFixed(r):e.toString()}},s=n;s.CONSISTENT=new n(!1,0,2,", "),s.EXACT=new n(!0,0,void 0,", "),s.MINIFIED=new n(!0,0,void 0,","),s.SIMPLIFIED=new n(!0,5e-4,3,", ");var o=class{static need(e,t,r){if(!0!==e){let e=void 0===r?"(not provided)":`[${Array.prototype.slice.call(r).join(", ")}]`,a=`Precondition failed\n\nMessage: ${void 0===t?"(not provided)":t}\n\nArgs: ${e}`;throw new Error(a)}}static notNull(e){o.need(null!=e,"notNull")}static snappedCosSin(e){let t=Math.PI/4,r=Math.round(e/t);if(r*t===e){let e=Math.sqrt(.5);return[[1,0],[e,e],[0,1],[-e,e],[-1,0],[-e,-e],[0,-1],[e,-e]][7&r]}return[Math.cos(e),Math.sin(e)]}};var u=class{static from(e){if(e instanceof u)return e;if("number"==typeof e)return new u(e,0);throw new a("Unrecognized value type.",{v:e})}static polar(e,t){let[r,a]=o.snappedCosSin(t);return new u(e*r,e*a)}static realPartOf(e){if(e instanceof u)return e.real;if("number"==typeof e)return e;throw new a("Unrecognized value type.",{v:e})}static imagPartOf(e){if(e instanceof u)return e.imag;if("number"==typeof e)return 0;throw new a("Unrecognized value type.",{v:e})}constructor(e,t){this.real=e,this.imag=t}static rootsOfQuadratic(e,t,r){if(e=u.from(e),t=u.from(t),r=u.from(r),e.isEqualTo(0)){if(!t.isEqualTo(0))return[r.times(-1).dividedBy(t)];if(!r.isEqualTo(0))return[];throw Error("Degenerate")}let a=t.times(t).minus(e.times(r).times(4)).sqrts(),i=t.times(-1),n=e.times(2);return a.map((e=>i.minus(e).dividedBy(n)))}isEqualTo(e){return e instanceof u?this.real===e.real&&this.imag===e.imag:"number"==typeof e&&(this.real===e&&0===this.imag)}isApproximatelyEqualTo(e,t){if(e instanceof u||"number"==typeof e){let r=this.minus(u.from(e));return Math.abs(r.real)<=t&&Math.abs(r.imag)<=t&&r.abs()<=t}return!1}norm2(){return this.real*this.real+this.imag*this.imag}abs(){return Math.sqrt(this.norm2())}unit(){let e=this.norm2();return e<1e-5?u.polar(1,this.phase()):this.dividedBy(Math.sqrt(e))}plus(e){let t=u.from(e);return new u(this.real+t.real,this.imag+t.imag)}minus(e){let t=u.from(e);return new u(this.real-t.real,this.imag-t.imag)}times(e){let t=u.from(e);return new u(this.real*t.real-this.imag*t.imag,this.real*t.imag+this.imag*t.real)}dividedBy(e){let t=u.from(e),r=t.norm2();if(0===r)throw new Error("Division by Zero");let a=this.times(t.conjugate());return new u(a.real/r,a.imag/r)}sqrts(){let[e,t]=[this.real,this.imag],r=Math.sqrt(Math.sqrt(e*e+t*t));if(0===r)return[u.ZERO];if(0===t&&e<0)return[new u(0,r),new u(0,-r)];let a=this.phase()/2,i=u.polar(r,a);return[i,i.times(-1)]}conjugate(){return new u(this.real,-this.imag)}toString(e){return e=e||s.EXACT,e.allowAbbreviation?this.toStringAllowSingleValue(e):this.toStringBothValues(e)}neg(){return new u(-this.real,-this.imag)}raisedTo(e){return.5===e&&0===this.imag&&this.real>=0?new u(Math.sqrt(this.real),0):u.ZERO.isEqualTo(e)?u.ONE:this.isEqualTo(u.ZERO)?u.ZERO:this.ln().times(u.from(e)).exp()}exp(){return u.polar(Math.exp(this.real),this.imag)}cos(){let e=this.times(u.I);return e.exp().plus(e.neg().exp()).times(.5)}sin(){let e=this.times(u.I);return e.exp().minus(e.neg().exp()).dividedBy(new u(0,2))}tan(){return this.sin().dividedBy(this.cos())}ln(){return new u(Math.log(this.abs()),this.phase())}phase(){return Math.atan2(this.imag,this.real)}toStringAllowSingleValue(e){return Math.abs(this.imag)<=e.maxAbbreviationError?e.formatFloat(this.real):Math.abs(this.real)<=e.maxAbbreviationError?Math.abs(this.imag-1)<=e.maxAbbreviationError?"i":Math.abs(this.imag+1)<=e.maxAbbreviationError?"-i":`${e.formatFloat(this.imag)}i`:this.toStringBothValues(e)}toStringBothValues(e){let t=this.imag>=0?"+":"-",r=e.allowAbbreviation&&Math.abs(Math.abs(this.imag)-1)<=e.maxAbbreviationError?"":e.formatFloat(Math.abs(this.imag));return(e.allowAbbreviation||void 0===e.fixedDigits||this.real<0?"":"+")+e.formatFloat(this.real)+t+r+"i"}},h=u;h.ZERO=new u(0,0),h.ONE=new u(1,0),h.I=new u(0,1);var f={MAX_QUBIT_COUNT:16};function j(e,t={},r=document){let a=new CustomEvent(e,{bubbles:!0,cancelable:!0,detail:t});return r.dispatchEvent(a)}function y(e,t){return null!=e&&t in e}var c=[Float32Array,Float64Array,Int8Array,Int16Array,Int32Array,Uint8Array,Uint16Array,Uint32Array,Uint8ClampedArray];function g(e,t){if(e===t||T(e)&&T(t))return!0;let r=R(e,t);return void 0!==r?r:!(b(e)||b(t)||!k(e,t))&&(e instanceof Map&&t instanceof Map?M(e,t):e instanceof Set&&t instanceof Set?z(e,t):S(e)&&S(t)?v(e,t):I(e,t))}function S(e){return Array.isArray(e)||!c.every((t=>!(e instanceof t)))}function T(e){return"number"==typeof e&&isNaN(e)}function R(e,t){return!b(e)&&y(e,"isEqualTo")&&"function"==typeof e.isEqualTo?e.isEqualTo(t):!b(t)&&y(t,"isEqualTo")&&"function"==typeof t.isEqualTo?t.isEqualTo(e):void 0}function b(e){return null==e||"string"==typeof e||"number"==typeof e||"boolean"==typeof e}function M(e,t){if(e.size!==t.size)return!1;for(let[r,a]of e){if(!t.has(r))return!1;let e=t.get(r);if(!g(a,e))return!1}return!0}function z(e,t){if(e.size!==t.size)return!1;for(let r of e)if(!t.has(r))return!1;return!0}function k(e,t){return typeof e==typeof t}function v(e,t){if(e.length!==t.length)return!1;for(let r=0;r<e.length;r++)if(!g(e[r],t[r]))return!1;return!0}function w(e){let t=new Set;for(let r in e)y(e,r)&&t.add(r);return t}function I(e,t){let r=w(e);if(!z(r,w(t)))return!1;for(let a of r)if(a!==Symbol.iterator&&!g(e[a],t[a]))return!1;let a=y(e,Symbol.iterator),i=y(t,Symbol.iterator);return!(a!==i||a&&i&&!F(e,t))}function F(e,t){let r=t[Symbol.iterator]();for(let t of e){let e=r.next();if(e.done||!g(t,e.value))return!1}return r.next().done}var re=e=>"number"==typeof e&&1<=e&&e<=f.MAX_QUBIT_COUNT;var d="◦";var p="Bloch";var m="•";var E="H";var x="Measure";var A="P";var G="QFT†";var N="QFT";var C="X^½";var Z="Rx";var Q="Ry";var X="Rz";var V="S†";var _="S";var H="…";var L="Swap";var W="T†";var Y="T";var J="|0>",K="|1>";var ee="X";var te="Y";var ae="Z";export{h as Complex,f as Config,a as DetailedError,s as Format,d as SerializedAntiControlGateType,p as SerializedBlochDisplayType,m as SerializedControlGateType,E as SerializedHGateType,x as SerializedMeasurementGateType,A as SerializedPhaseGateType,G as SerializedQftDaggerGateType,N as SerializedQftGateType,C as SerializedRnotGateType,Z as SerializedRxGateType,Q as SerializedRyGateType,X as SerializedRzGateType,V as SerializedSDaggerGateType,_ as SerializedSGateType,H as SerializedSpacerGateType,L as SerializedSwapGateType,W as SerializedTDaggerGateType,Y as SerializedTGateType,J as SerializedWrite0GateType,K as SerializedWrite1GateType,ee as SerializedXGateType,te as SerializedYGateType,ae as SerializedZGateType,i as UNICODE_FRACTIONS,o as Util,q as angleDenominator,O as angleNumerator,j as emitEvent,g as equate,y as hasOwnProperty,B as isAngleGreaterThan,U as isAngleLessThan,re as isResizeableSpan,$ as isValidAngle,l as piCoefficient,D as radian,P as reduceAngle};

