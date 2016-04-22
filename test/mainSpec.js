describe('Template', function() {
    var Template;

    beforeEach(function() {
        module('templateApp');

        inject(function(_Template_) {
           Template = _Template_;
        });
    });

    it('!!', function() {
        expect(2).toEqual(2);
    });

});