var e={};var t,r=Symbol.for("react.element"),o=Symbol.for("react.portal"),n=Symbol.for("react.fragment"),s=Symbol.for("react.strict_mode"),i=Symbol.for("react.profiler"),f=Symbol.for("react.provider"),c=Symbol.for("react.context"),u=Symbol.for("react.server_context"),a=Symbol.for("react.forward_ref"),l=Symbol.for("react.suspense"),y=Symbol.for("react.suspense_list"),m=Symbol.for("react.memo"),p=Symbol.for("react.lazy"),d=Symbol.for("react.offscreen");t=Symbol.for("react.module.reference");function v(e){if("object"===typeof e&&null!==e){var t=e.$$typeof;switch(t){case r:switch(e=e.type,e){case n:case i:case s:case l:case y:return e;default:switch(e=e&&e.$$typeof,e){case u:case c:case a:case p:case m:case f:return e;default:return t}}case o:return t}}}e.ContextConsumer=c;e.ContextProvider=f;e.Element=r;e.ForwardRef=a;e.Fragment=n;e.Lazy=p;e.Memo=m;e.Portal=o;e.Profiler=i;e.StrictMode=s;e.Suspense=l;e.SuspenseList=y;e.isAsyncMode=function(){return!1};e.isConcurrentMode=function(){return!1};e.isContextConsumer=function(e){return v(e)===c};e.isContextProvider=function(e){return v(e)===f};e.isElement=function(e){return"object"===typeof e&&null!==e&&e.$$typeof===r};e.isForwardRef=function(e){return v(e)===a};e.isFragment=function(e){return v(e)===n};e.isLazy=function(e){return v(e)===p};e.isMemo=function(e){return v(e)===m};e.isPortal=function(e){return v(e)===o};e.isProfiler=function(e){return v(e)===i};e.isStrictMode=function(e){return v(e)===s};e.isSuspense=function(e){return v(e)===l};e.isSuspenseList=function(e){return v(e)===y};e.isValidElementType=function(e){return"string"===typeof e||"function"===typeof e||e===n||e===i||e===s||e===l||e===y||e===d||"object"===typeof e&&null!==e&&(e.$$typeof===p||e.$$typeof===m||e.$$typeof===f||e.$$typeof===c||e.$$typeof===a||e.$$typeof===t||void 0!==e.getModuleId)};e.typeOf=v;const S=e.ContextConsumer,b=e.ContextProvider,$=e.Element,C=e.ForwardRef,M=e.Fragment,P=e.Lazy,x=e.Memo,w=e.Portal,F=e.Profiler,L=e.StrictMode,g=e.Suspense,E=e.SuspenseList,z=e.isAsyncMode,R=e.isConcurrentMode,_=e.isContextConsumer,h=e.isContextProvider,j=e.isElement,A=e.isForwardRef,O=e.isFragment,T=e.isLazy,V=e.isMemo,I=e.isPortal,k=e.isProfiler,q=e.isStrictMode,B=e.isSuspense,D=e.isSuspenseList,G=e.isValidElementType,H=e.typeOf;export{S as ContextConsumer,b as ContextProvider,$ as Element,C as ForwardRef,M as Fragment,P as Lazy,x as Memo,w as Portal,F as Profiler,L as StrictMode,g as Suspense,E as SuspenseList,e as default,z as isAsyncMode,R as isConcurrentMode,_ as isContextConsumer,h as isContextProvider,j as isElement,A as isForwardRef,O as isFragment,T as isLazy,V as isMemo,I as isPortal,k as isProfiler,q as isStrictMode,B as isSuspense,D as isSuspenseList,G as isValidElementType,H as typeOf};
