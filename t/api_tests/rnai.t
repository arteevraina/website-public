#!/usr/bin/env perl

# Unit tests regarding "Rnai" instances.
{
    # Package name is the same as the filename (sans suffix, i.e. no .t ending)
    package rnai;

    # Limit the use of unsafe Perl constructs.
    use strict;

    # We use Test::More for all tests, so include that here.
    use Test::More;

    # This variable will hold a reference to a WormBase API object.
    my $api;

    # A setter method for passing on a WormBase API object from t/api.t to
    # the subs of this package.
    sub config {
        $api = $_[0];
    }


    # Unit test for sequence() - ensures correct retrieval from both DNA_text and PCR_product
    sub test_sequence {
        # testing fetching sequence from DNA_text
        my $rnai = $api->fetch({ class => 'Rnai', name => 'WBRNAi00000176' });

        can_ok('WormBase::API::Object::Rnai', ('sequence'));

        my $sequence = $rnai->sequence();

        isnt($sequence->{'data'}, undef, 'data returned');
        isnt($sequence->{'data'}[0]->{'sequence'}, undef, 'sequence data returned');
        is  ($sequence->{'data'}[0]->{'sequence'}, 'cgcgcagattcaatgcaaccagtttgtattgacaggtaaattatatttcaaatttcatatttcaattttattttacagaatggttgattggttcagtttccatctttctaatttccaatatcgatacacctggacagattggaaggattgtttgaatgtatgtttttattttctattgttcataacattgcacggtaatatttgcagaaagatgcattttccggcagtcaaatctttgtacgagaagtcatagaaaagtgtcgtcgttttggatcttatgagaaaattatcgctgcattgccccaagattttgtcaagattcatccatgctctccagaagttcgatatctcattgatgaaggtaaataactactttttggaaaaatcaaaacttgtaatttcagaagacactgcactagttcaacgagcggaaacattcactcaaatgttccaagaacgtcagccagctgaagcattcctcaatgagcttaaatcaaatgatgaaaatgacgaattgccatataacattaatgaattcggtcttttcgtaatggttatgctcaaaatggcatcgaagacttattcacacaacttctcagctctattcagg', 'sequence data correct');


        # testing fetching sequence from PCR_product
        my $rnai_pcr = $api->fetch({ class => 'Rnai', name => 'WBRNAi00088157' });

        my $sequence_pcr = $rnai_pcr->sequence();

        isnt($sequence_pcr->{'data'}, undef, 'data returned');
        isnt($sequence_pcr->{'data'}[0]->{'sequence'}, undef, 'sequence data returned');
        is  ($sequence_pcr->{'data'}[0]->{'sequence'},
            'tggacgacagtcaagagtcgagtttttcggtttccaaatatgaaacgtaagtcgaatagagtacggtattcggaaaatctgaaatttaaatttttagaaatgatgatggatctatgggccaattcatttcaataaatgtaagttaaacttccattaacagtttttcaaaagtctgagaaggtagatcaatataattcattagagcgcatttgctcgccttggatcaaaaacttggaaatctataataataatttgaaggaatgtgaacgggaaattcaaatgttagaacgtgacattcgtcaacagaaagagtccagtgcaaatgcgaaaacagcgataacattcgatcaacttcggaaaattcatacgtacgttccgggccgtccgatcagttttcccgtcggcctcaatagctcacacaggtaaagcgccaagtgtgaaaaatggctgaatagtgggtgaaggggcgctggcgggtgaacgatgggggaaaaatgggcgaaggaccgcaaaaagacgaagcaatgggtgaataaattgaccaatccgaaaatcaaaaaagaagtaaaaaaggagcatagcaaagtatttccgaagtattcatgcataactagtatacgtgtttatggaagtgtttattgttaacaatgttacaatcaattgattgttgtaatgttcacttcatttccgaacatctactattagagtcatctgttgttgaataatgtgaaaaacattttgttacttttttaagggttatatttatagaaaaaataccaatttgttatttcccacaagtttggacattcatattacattctcagtcgaacaatcacctatataagagttgattgagcatatagacgtcttactttaaaagactcataactctgttggcatttgaattaataaaatgtggccaactgaaaagttgttgacaataatgtgaaaaacattttgttagttggtaactttttgttatctttagtgactgcggagatgtgggcttcaaaagataaccaaaatattctagatttgtacttaaatatatctcagttctcgataaagatgaagagatacttacaactatcaatatgtttattgttttaaacttaacaacgttgtagttgataactttttgatatcttgcctctagaattagatacatccattttaatacaggaggttttaattttcagagctccaaggaatgtcggtttgacttatcgaaagcaccgaacttagcaaaaaaacttatagaaacaaacaattcaacatatttctacaatacctgataaaaatttgataatttttgaaaaaaaattttttttgatttttgaaaaaaaaatccaaagggtccccccttacaaaatttttcaaaattttttttttggaaactttttataatatgattagatgttatagaaaaatccaatgtttgtaattatttctagtttgtatgttctgaacacgatttcggacgaaaacctgaggtgtagtagaacaactaagttcaaaaaacgcgttcactttggatgcgtatatctccgtggaaaaatttttgatggcaaagtgatcaactacaaagttgtttatcttaatctgaagtacaactttgtagtttattgtttcttgtcaaaaaaattgttggtcgagataaagttgtgttcattttggcaacttcatgcttgaattttcttcttctttttctattcctgtctcaatcaacaatttttttgacaagaaacaataaactacaaagttgtacttcagattaagatgaacaactttgtagttgatcactttgccatcaaaaatttttccacggagatatacgcatccaaagtgaacgcgttttttgaacttagttgttctactacacctcaggtcttcttccgaaatcgtgttcagaacatacaaactagaaataattacaaacattgcatttttctatagcatctaatcatattataaaaagtttccaaaaactttttttttcaacaattttttttcaacaattttcatcataaggggggacccttatgatcaaagtaatgatttatcaaattggatgaagagggtcatatttagaatttttatcgaaatttcattcgaaactcttaaagttgaaacggaaatatcttacttagtactattcgatctatttttcagcgtttcaatgcgttttttaacaccaataaatcatttcaattcaacgcttactctcattatgagtttcatagcaacgacactccgaaataaccctagcgcgccctctttagcgaaaattttattcaatttttttttgctttttttgcaatttttctcgttttttttcacgattaccgctaattttgcgtgattttgtgagcaacatatttttctttttcacatttttataatttgcagataaaaatcgagaaaatcaacgaaaaggatccttcaaaacgacggaataggaaaaagatgccaaaaatcaggtattttcagaaatattgagaaactctgcgtctattcttctgttaactaattataattggtttcttattcgaaaaatataaatttttgtcacgaaaaaaagcgagaaataatcttcgaattcagatatttcgtcccgacgcaacttcgccggcttcgacgaggaatcctgcagcgagggacacgattatgagctgttaaagtgagttttaaagttttaaaatgtattctcccgaaagaaaaatcgtcaaactaactctaaagcatgataatttttacaggagtgtcgccggcaccgactccgaacgagaaaagctccgacgaccgcaaacgagagccgaaggaatctggaaagcgaaggtaatattttattttcaaatatcgatacttgtttctaacgagcgaaaatgtataatgtaatgtaataatgattaatcttctttattaaacttctttaaaattaatcatttgaatttttcagaaaatggatcgataaaatcgcttactggaggaagacaaaaggaagaaaagcggaaacgagtcaattgccgatgacaccagaggacgattcatcgaaatcatcaaaagatgaaataaattattttgtttttttttcgatttaaaataaacgataatactataatatactcgttttatgaatattattcttcactgaaaagcaaaaggaggggaatggaaacgatagccttcacccatcgctcacccatcgctcacccattagcgagccgctaacatgcgaacggcggcccaccggtgtgcgcgctgttcgtgtgtcggcggttcccccctcgcctatatgcggtcccccctcgcctatatgcggtcccccctcgcctatatgcggtccaccggtgggccgccgctcgcacttggcgctttacctgtgcagttgggagagcgtacgactgaagatcgtaaggtcaccagttcgatcctggtttggggcaatctatttttacttttttggtattcttatataaacttggtaattttaagactctctacattgcttggaccacacaaagagctattctttgataggatatgtcgggcagccgatatacaaagggcatctttgaaaaatcgtttgaaatcaaatataaatgtaggatattttttaaattcaattttccaatatttttgactaatagtaagattgcaattttccagaaattcgagcccagcacacctctgtcgtttcaaccgggattcgattctcagagctctctttcaacgacttcagagagccaaaattttgtggtgaccccaacaactcttagcagtttattgaacaatcacacagtaagtttttatgagattgtcgtagtaggtaggcccgtgcccatattatcataacaagtctacctgacctacctgactattacacattttctgcattttgaggccactttagatgataactttagatgtagatgtaaacctttagatgtaaaccaactgagataataacaaataagtaggtcttgtagtgtagcagtaggtaggcacaaggaaggtattatatgcctacgtcgatgttatactggtttaattatcaaatcttttaattttcaataaataatttaagcggaagaatcacattgaaatgctggctccactagcgtccgaagaggagttgatgagatttcctgcggaacgacagtttgatctaatgcaaattggatttagttacgatgaagtgaagcagttgctggaaatgtttgaaaaattcaagaatgacgttcaagagattaacaggcttcatacattgacacaggtgaggaataacggttactgcagagaaacgagagtgtatgtattctttggatttggttgaaggcacctaattcagattctctggattaattgttcctaaaaaatatttttgagatcctgaatcaattttgcaactacatctcaatgtacgcaccacccaatctgaaaatgatatcatcggcgttcaatttgctagaacttggaaactcagctcatgaagtgaaaagggttttactgaaagcggtaatctaaatattccatcaaaaaatataactaaatgaaatttttatagcgtcgtcgtgaagaatcagaagaatcagatgtttcattttccaaaaagccacgtccttcttctagatctcctgcatctccaaatcgagatgatctattgttgggactcgatcgttctccgcccagcgatgatggaactcagaaagttt',
            'sequence data from pcr product correct');

    }

    # Unit test for movies - make sure it links out to the correct source
    sub test_movies {
        can_ok('WormBase::API::Object::Rnai', ('movies'));

        # link out to RNAi DB
        my $rnai_db = $api->fetch({ class => 'Rnai', name => 'WBRNAi00008269' });
        my $db_movies = $rnai_db->movies();

        # link to wormbase hosted movies
        my $rnai_orig = $api->fetch({ class => 'Rnai', name => 'WBRNAi00081349' });
        my $orig_movies = $rnai_orig->movies();

        isnt($db_movies->{'data'}, undef, 'data returned');
        isnt($orig_movies->{'data'}, undef, 'data returned');
        is  ($db_movies->{'data'}[0]->{id}, 'GL1/GL1_8/8h2-0101.mov', 'correct rnaidb id returned');
        is  ($db_movies->{'data'}[0]->{class}, 'RNAi', 'correct class for rnaidb linking returned');
        is  ($orig_movies->{'data'}[0]->{id}, '009.G06.f1.term.mov', 'correct movie id returned');
        is  ($orig_movies->{'data'}[0]->{class}, 'Movie', 'correct class for stored movie linking returned');

    }

}

1;

