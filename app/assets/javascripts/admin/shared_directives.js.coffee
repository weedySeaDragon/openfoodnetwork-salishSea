sharedDirectivesModule = angular.module("ofn.shared_directives", [])

sharedDirectivesModule.directive "datetimepicker", ->
  require: "ngModel"
  link: (scope, element, attrs, ngModel) ->
    element.datetimepicker
      dateFormat: "yy-mm-dd"
      timeFormat: "HH:mm:ss"
      stepMinute: 15
      onSelect: (dateText, inst) ->
        scope.$apply (scope) ->
          # Fires ngModel.$parsers
          ngModel.$setViewValue dateText

sharedDirectivesModule.directive "datepicker", ->
  require: "ngModel"
  link: (scope, element, attrs, ngModel) ->
    element.datepicker
      dateFormat: "yy-mm-dd"
      onSelect: (dateText, inst) ->
        scope.$apply (scope) ->
          # Fires ngModel.$parsers
          ngModel.$setViewValue dateText

sharedDirectivesModule.directive "ofnSelect2MinSearch", ->
  require: 'ngModel'
  link: (scope, element, attrs, ngModel) ->
    element.select2
      minimumResultsForSearch: attrs.ofnSelect2MinSearch

    ngModel.$formatters.push (value) ->
      if (value)
        element.select2('val', value);

sharedDirectivesModule.directive "ofnToggleColumn", ->
  link: (scope, element, attrs) ->
    element.addClass "selected" if scope.column.visible
    element.click "click", ->
      scope.$apply ->
        if scope.column.visible
          scope.column.visible = false
          element.removeClass "selected"
        else
          scope.column.visible = true
          element.addClass "selected"