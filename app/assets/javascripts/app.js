'use strict';

var app = angular.module('gbg', ['gbg.services']);

function ListCtrl($scope, $location, Boardgame) {

    $scope.bgs;

    var listNamespace = {
        page: 1,
        allBgs: [],
        currentFilters: {},
        grabbingBgs: false,
        getUrlFilters: function() {

        },
        filter: function(bgs, filters) {
            $scope.bgs = listNamespace.allBgs;
            console.log($scope.bgs);
            $scope.bgs = _.sortBy($scope.bgs, function(bg) { return parseFloat(bg.rating) }).reverse();
            return listNamespace.allBgs;
        },
        getNextPage: function() {
            Boardgame.get(listNamespace.page).then(function(data) {
                listNamespace.page++;
                listNamespace.allBgs = listNamespace.allBgs.concat(data.bgs);
                var newset = listNamespace.filter(data.bgs, listNamespace.currentFilters);
                if (newset.length < 10) {
                    listNamespace.getNextPage();
                }
            });
        }
    }

    listNamespace.getNextPage();
}

angular.module('gbg.services', [], function($provide) {
    $provide.factory('Boardgame', function($http) {
        var Boardgame = function(data) {
            angular.extend(this, data);
        }

        Boardgame.get = function(page) {
            return $http.get('/api/bg?page='+page).then(function(response) {
                return new Boardgame(response.data);
            })
        }

        return Boardgame;
    });
});
